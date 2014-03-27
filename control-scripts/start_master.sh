#!/bin/bash

. common.sh

MYSQL_SERVER_ID=1

if [ ! -e $MYSQL_DATA_PATH ]; then
    mkdir -p $MYSQL_DATA_PATH 
    docker run -v $MYSQL_DATA_PATH:/var/lib/mysql mysql /usr/bin/mysql_install_db
fi

for dir in $(find $MYSQL_PERSISTED_DATA_PATH -type d); do 
	rsync --exclude='mysql' --exclude='performance_schema' -av $dir $MYSQL_DATA_PATH/
done

docker run -d --name mysql-master \
	-p 3306:3306 -v $MYSQL_DATA_PATH:/var/lib/mysql \
	-e SERVER_ID=$MYSQL_SERVER_ID \
	-e MYSQL_PASS=$MYSQL_PASS \
	mysql

