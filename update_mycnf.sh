#!/bin/bash

if [ -f /.mysql_conf_updated ]; then
        echo "MySQL conf has already been updated"
        exit 0
fi

echo "=> Updating my.cnf"

SERVER_ID=${SERVER_ID:-0}
INNODB_BUFFER_POOL_SIZE=${INNODB_BUFFER_POOL_SIZE:-256M}
INNODB_USE_NATIVE_AIO=${INNODB_USE_NATIVE_AIO:-1}

echo "log-bin" >> /etc/mysql/conf.d/my.cnf
echo "server-id=$SERVER_ID" >> /etc/mysql/conf.d/my.cnf
echo "innodb_buffer_pool_size=$INNODB_BUFFER_POOL_SIZE" >> /etc/mysql/conf.d/my.cnf
echo "slave-skip-errors = 1062,1054" >> /etc/mysql/conf.d/my.cnf
echo "replicate-ignore-db = information_schema" >> /etc/mysql/conf.d/my.cnf
echo "replicate-ignore-db = performance_schema" >> /etc/mysql/conf.d/my.cnf
echo "replicate-ignore-db = mysql" >> /etc/mysql/conf.d/my.cnf
echo "innodb_use_native_aio = $INNODB_USE_NATIVE_AIO" >> /etc/mysql/conf.d/my.cnf

touch /.mysql_conf_updated
echo "=> Done!"
