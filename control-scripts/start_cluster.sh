#!/bin/bash

./prepare_cluster.sh
./start_master.sh
sleep 5
./start_slave.sh
