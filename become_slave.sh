#!/bin/bash

/start.sh >& /dev/null & 

echo "=> Creating a user on master '$MASTER_PORT_3306_TCP_ADDR'"
RET=1
while [[ RET -ne 0 ]]; do
        sleep 5
	mysql -uadmin -p${MYSQL_PASS} -h${MASTER_PORT_3306_TCP_ADDR} \
        	-e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY '${MYSQL_PASS}';"

	mysql -uadmin -p${MYSQL_PASS} -h${MASTER_PORT_3306_TCP_ADDR} \
        	-e "SHOW MASTER STATUS\G" > /tmp/master_status
        RET=$?
done

FILE=`cat /tmp/master_status | grep File | cut -f2 -d: | tr -d " "`
POSITION=`cat /tmp/master_status | grep Position | cut -f2 -d: | tr -d " "`

echo "Master log file is $FILE"
echo "Master log position is $POSITION"

echo "=> Becoming Slave of '$MASTER_PORT_3306_TCP_ADDR'"
RET=1
while [[ RET -ne 0 ]]; do
        sleep 5

        mysql -e "STOP SLAVE;"
        mysql \
        -e "CHANGE MASTER TO 
                MASTER_HOST='${MASTER_PORT_3306_TCP_ADDR}',
		MASTER_LOG_FILE='${FILE}',
		MASTER_LOG_POS=${POSITION},
                MASTER_USER='repl',
                MASTER_PASSWORD='${MYSQL_PASS}';"

        mysql -e "START SLAVE;"
        RET=$?
done

echo "=> Done!"

