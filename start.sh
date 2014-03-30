#!/bin/bash

if [ ! -f /.mysql_admin_created ]; then
        /create_mysql_admin_user.sh
        /update_mycnf.sh
fi

if [ ${MASTER_PORT_3306_TCP_ADDR}Z != 'Z' ]; then
	sh -c "sleep 10; mysqladmin start slave" &
fi

exec mysqld_safe
