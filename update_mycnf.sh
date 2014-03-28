#!/bin/bash

SERVER_ID=${SERVER_ID:-0}
INNODB_BUFFER_POOL_SIZE=${INNODB_BUFFER_POOL_SIZE:-256M}

echo "log-bin" >> /etc/mysql/conf.d/my.cnf
echo "server-id=$SERVER_ID" >> /etc/mysql/conf.d/my.cnf
echo "innodb_buffer_pool_size=$INNODB_BUFFER_POOL_SIZE" >> /etc/mysql/conf.d/my.cnf
