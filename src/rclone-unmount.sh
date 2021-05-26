#!/bin/bash

# load config data located in script directory
SCRIPT_DIR=$(dirname $(readlink -f "$0"))
source $SCRIPT_DIR/rclone-backup.conf || exit
if [ "" ==  "$remote" ]; then
    echo "rclone backup config not defined"
    exit 1
fi

# check if remote is mounted
PID=`ps -ef | grep rclone | grep mount | grep $remote | awk '{print $2}'`

if [ "" !=  "$PID" ]; then
    kill -TERM $PID && echo "Unmounted $mountpoint (PID=$PID)"
else
    echo "Can't find rclone mount process for $remote"
fi
