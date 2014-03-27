#!/bin/bash

echo "=> Creating a user on master '$MASTER_PORT_3306_TCP_ADDR'"
mysql -uadmin -p${MYSQL_PASS} -h${MASTER_PORT_3306_TCP_ADDR} \
        -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY '${MYSQL_PASS}';"

echo "=> Becoming Slave of '$MASTER_PORT_3306_TCP_ADDR'"
RET=1
while [[ RET -ne 0 ]]; do
        sleep 5

        mysql -e "STOP SLAVE;"
        mysql \
        -e "CHANGE MASTER TO 
                MASTER_HOST='${MASTER_PORT_3306_TCP_ADDR}',
                MASTER_USER='repl',
                MASTER_PASSWORD='${MYSQL_PASS}';"

        mysql -e "START SLAVE;"
        RET=$?
done

echo "=> Done!"

