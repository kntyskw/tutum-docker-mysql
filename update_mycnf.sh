#!/bin/bash

SERVER_ID=${SERVER_ID:-0}

echo "log-bin" >> /etc/mysql/conf.d/my.cnf
echo "server-id=$SERVER_ID" >> /etc/mysql/conf.d/my.cnf
