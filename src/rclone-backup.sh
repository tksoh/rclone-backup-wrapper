#!/bin/bash

# load config data located in script directory
SCRIPT_DIR=$(dirname $(readlink -f "$0"))
source $SCRIPT_DIR/rclone-backup.conf || exit
if [ "" ==  "$remote" ]; then
    echo "rclone backup config not defined"
    exit 1
fi

echo "=== PARAMETERS ==="
echo "remote: $remote"
echo "backupdir: $backupdir"
echo "dirlist: ${dirlist[@]}"
echo 

# check if remote is mounted
PID=`ps -ef | grep rclone | grep mount | grep $remote | awk '{print $2}'`

if [ "" ==  "$PID" ]; then
    echo "$remote is not mounted"
    exit
fi

# start backup
echo "=== BACKUP PROGRESS ==="

backuplog=/tmp/rclone-backup.log
echo -n "backup begin:    " > $backuplog
date +"%F %T">> $backuplog
for dir in "${dirlist[@]}"
do
    echo "backing up '$dir' ..."
    rclone copy $HOME/$dir $remote:$backupdir/$dir --copy-links $@
done

# update backup log
echo "update backup log"
echo -n "backup complete: " >> $backuplog
date +"%F %T">> $backuplog
rclone copy $backuplog $remote:$backupdir --no-traverse --copy-links $@

echo "backup done"
