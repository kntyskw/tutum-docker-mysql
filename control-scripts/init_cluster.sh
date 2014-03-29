#!/bin/bash

source common.sh

rm -fr $MYSQL_DATA_PATH
mv $MYSQL_PERSISTED_DATA_PATH ${MYSQL_PERSISTED_DATA_PATH}.`date +%Y%m%d%H%M`

mkdir -p $MYSQL_PERSISTED_DATA_PATH

docker run -i -t \
	-v $MYSQL_PERSISTED_DATA_PATH:/var/lib/mysql \
	-e MYSQL_PASS=$MYSQL_PASS \
	mysql /usr/bin/mysql_install_db

