#!/bin/bash

. common.sh

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
	# Start master server
	docker run -d --name mysql-master -v $MYSQL_DATA_PATH:/var/lib/mysql \
		-e SERVER_ID=${MYSQL_MASTER_SERVER_ID} \
		-e MYSQL_PASS=${MYSQL_PASS} \
		mysql /start.sh
	# Start slave server and make it slave
	docker run --link mysql-master -v $MYSQL_PERSISTED_DATA_PATH:/var/lib/mysql \
		-e SERVER_ID=${MYSQL_SLAVE_SERVER_ID} \
		-e MYSQL_PASS=${MYSQL_PASS} \
		mysql /become_slave.sh
	docker stop mysql-master
	docker rm mysql-master
fi


docker run -d --name mysql-master \
	-p ${MYSQL_MASTER_PORT}:3306 -v $MYSQL_DATA_PATH:/var/lib/mysql \
	-e INNODB_BUFFER_POOL_SIZE=20G \
	-e SERVER_ID=$MYSQL_MASTER_SERVER_ID \
	-e MYSQL_PASS=$MYSQL_PASS \
	mysql

