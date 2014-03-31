#!/bin/bash

source common.sh

./stop_cluster.sh >& /dev/null

rm -fr $MYSQL_DATA_PATH
mv $MYSQL_PERSISTED_DATA_PATH ${MYSQL_PERSISTED_DATA_PATH}.`date +%Y%m%d%H%M`

