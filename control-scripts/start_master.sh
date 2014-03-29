#!/bin/bash

. common.sh

MYSQL_SERVER_ID=1

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
fi


docker run -d --name mysql-master \
	-p 3306:3306 -v $MYSQL_DATA_PATH:/var/lib/mysql \
	-e INNODB_BUFFER_POOL_SIZE=20G \
	-e SERVER_ID=$MYSQL_SERVER_ID \
	-e MYSQL_PASS=$MYSQL_PASS \
	mysql

