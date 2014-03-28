#!/bin/bash

source common.sh

MYSQL_SERVER_ID=2

docker run -d --name mysql-slave \
	--link mysql-master:master \
	-v $MYSQL_PERSISTED_DATA_PATH:/var/lib/mysql \
	-p 13306:3306 \
	-e INNODB_BUFFER_POOL_SIZE=256M \
	-e MYSQL_PASS=$MYSQL_PASS \
	-e SERVER_ID=$MYSQL_SERVER_ID \
	mysql

