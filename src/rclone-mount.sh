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

logfile=/tmp/rclone-$remote-mount.log

if [ "" !=  "$PID" ]; then
    echo "$remote already mounted as $mountpoint (PID = $PID)"
else
    echo "mounting $remote as $mountpoint (log file: $logfile)"
    rclone -v --vfs-cache-mode writes mount $remote: $mountpoint --log-file=$logfile --daemon
fi
