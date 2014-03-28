#!/bin/bash

if [ ${MASTER_PORT_3306_TCP_ADDR}Z != 'Z' ]; then
	sh -c "sleep 10; /become_slave.sh" &
fi

exec mysqld_safe
