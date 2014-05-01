#!/bin/bash

. common.sh

docker run -d --name mysql-master \
	-p ${MYSQL_MASTER_PORT}:3306 -v $MYSQL_DATA_PATH:/var/lib/mysql \
	-e INNODB_BUFFER_POOL_SIZE=$MASTER_INNODB_BUFFER_POOL_SIZE \
	-e SERVER_ID=$MYSQL_MASTER_SERVER_ID \
	-e MYSQL_PASS=$MYSQL_PASS \
	mysql /start.sh
	#-i -t mysql bash

