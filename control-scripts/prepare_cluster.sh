#!/bin/bash

. common.sh

# Create database on EBS if none has been created
if [ ! -e $MYSQL_PERSISTED_DATA_PATH ]; then
	mkdir -p $MYSQL_PERSISTED_DATA_PATH

	docker run -i -t \
        	-v $MYSQL_PERSISTED_DATA_PATH:/var/lib/mysql \
        	-e MYSQL_PASS=$MYSQL_PASS \
        	mysql /usr/bin/mysql_install_db
fi

# Copy data from EBS to Ephemeral disk and setup master slave relationship if not done before
if [ ! -e $MYSQL_DATA_PATH ]; then
	mkdir -p $MYSQL_DATA_PATH 
	docker run -v $MYSQL_DATA_PATH:/var/lib/mysql mysql /usr/bin/mysql_install_db
	rsync -av \
		--exclude='mysql' \
		--exclude='performance_schema' \
		--exclude='master.info' \
		--exclude='relay-log.info' \
		--exclude='mysqld-bin.*' \
		--exclude='mysqld-relay-bin.*' \
		$MYSQL_PERSISTED_DATA_PATH/ $MYSQL_DATA_PATH/
	# Start temporary master server
	docker run -d --name mysql-tmp-master -v $MYSQL_DATA_PATH:/var/lib/mysql \
		-e SERVER_ID=${MYSQL_MASTER_SERVER_ID} \
		-e MYSQL_PASS=${MYSQL_PASS} \
		mysql /start.sh
	# Start slave server and make it slave
	docker run --link mysql-tmp-master:master -v $MYSQL_PERSISTED_DATA_PATH:/var/lib/mysql \
		-e SERVER_ID=${MYSQL_SLAVE_SERVER_ID} \
		-e MYSQL_PASS=${MYSQL_PASS} \
		mysql /become_slave.sh
	docker stop mysql-tmp-master
	docker rm mysql-tmp-master
fi

