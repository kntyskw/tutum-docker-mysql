#!/bin/bash

/update_mycnf.sh
/create_mysql_admin_user.sh

if [ ${MASTER_PORT_3306_TCP_ADDR}Z != 'Z' ]; then
	sh -c "sleep 10; mysqladmin start slave" &
fi

exec mysqld_safe
