#!/bin/bash

source common.sh

docker run -d --name mysql-slave \
	--link mysql-master:master \
	-v $MYSQL_PERSISTED_DATA_PATH:/var/lib/mysql \
	-p ${MYSQL_SLAVE_PORT}:3306 \
	-e INNODB_BUFFER_POOL_SIZE=$SLAVE_INNODB_BUFFER_POOL_SIZE \
	-e MYSQL_PASS=$MYSQL_PASS \
	-e SERVER_ID=$MYSQL_SLAVE_SERVER_ID \
	mysql /start.sh

