#!/bin/sh

LOG=/var/log/backup_storage.log

run()
{
	DATE=`date +'%y-%m-%d %H:%M:%S'`
	echo "[$DATE] $*" >> $LOG 2>&1
	$* >> $LOG 2>&1
}

log()
{
	DATE=`date +'%y-%m-%d %H:%M:%S'`
	echo "[$DATE] $*" >> $LOG 2>&1
}

log "start backup"

OPTS="-av"
if [ "x$1" = "xsync" ]; then
    OPTS="$OPTS --delete"
fi


# backup to /media/backup
BACKUP_MEDIA=/backup/storage
BACKUP2_MEDIA=/backup/xtorage
BACKUP2_MEDIA2=/backup/xtorage2

run rsync $OPTS --exclude tags /storage/ $BACKUP_MEDIA/
run rsync $OPTS --exclude torrent /xtorage/ $BACKUP2_MEDIA/

#run rsync $OPTS /xtorage/comic/ $BACKUP2_MEDIA/comic/
#run rsync $OPTS /xtorage/magazine/ $BACKUP2_MEDIA/magazine/
#run rsync $OPTS /xtorage/tag/ $BACKUP2_MEDIA/tag/
#run rsync $OPTS /xtorage/video/ $BACKUP2_MEDIA/video/

#run rsync $OPTS /xtorage/anime/ $BACKUP2_MEDIA2/anime/
#run rsync $OPTS /xtorage/dojinshi/ $BACKUP2_MEDIA2/dojinshi/
#run rsync $OPTS /xtorage/picture/ $BACKUP2_MEDIA2/picture/

log "finish backup"
