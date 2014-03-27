#!/bin/sh

source common.sh

test -e $MYSQL_PERSISTED_DATA_PATH ||\
    mkdir -p $MYSQL_PERSISTED_DATA_PATH

docker run -i -t \
	-v $MYSQL_PERSISTED_DATA_PATH:/var/lib/mysql \
	-e MYSQL_PASS=$MYSQL_PASS \
	mysql /usr/bin/mysql_install_db

