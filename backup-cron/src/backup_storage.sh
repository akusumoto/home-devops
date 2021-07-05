#!/bin/sh

function log()
{
    d=`date +"[%Y/%m/%d %H:%M:%S]"`
	echo "$d $@"
}

function is_mounted()
{
	src=$1
	dst=$2

	mountpoint $src > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		log "source directory '$src' is not mounted"
	    is_src_mounted=0
	else
		is_src_mounted=1
	fi

	mountpoint $dst > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		log "backup directory '$dst' is not mounted"
	    is_dst_mounted=0
	else
		is_dst_mounted=1
	fi

	if [ $is_src_mounted -eq 1 -a $is_dst_mounted -eq 1 ]; then
		return 0
	else
		return 1
	fi
}

function backup_letsencrypt1()
{
	echo
	log '=== backup letsencrypt ==='
	
	is_mounted /data/letsencrypt /backup/letsencrypt
	if [ $? -eq 0 ]; then
		if [ "x$1" = "x--sync" ]; then
			log 'rsync -avh --delete /data/letsencrypt/ /backup/letsencrypt'
			rsync -avh --delete /data/letsencrypt/ /backup/letsencrypt
		else
			log 'rsync -avh /data/letsencrypt/ /backup/letsencrypt'
			rsync -avh /data/letsencrypt/ /backup/letsencrypt
		fi
    fi
}

function backup_letsencrypt2()
{
	echo
	log '=== backup letsencrypt ==='

	is_mounted /data/letsencrypt /backup/backup
	if [ $? -eq 0 ]; then
		if [ "x$1" = "x--sync" ]; then
			log 'rsync -avh --delete /data/letsencrypt/ /backup/backup/letsencrypt'
			rsync -avh --delete /data/letsencrypt/ /backup/backup/letsencrypt
		else
			log 'rsync -avh /data/letsencrypt/ /backup/backup/letsencrypt'
			rsync -avh /data/letsencrypt/ /backup/backup/letsencrypt
		fi
	fi
}

function backup_owncloud_mysql()
{
	echo
	log '=== backup mysql of owncloud ==='

	is_mounted /data/owncloud/mysql /backup/backup
	if [ $? -eq 0 ]; then
		if [ "x$1" = "x--sync" ]; then
			log 'rsync -avh --delete /data/owncloud/mysql/ /backup/backup/owncloud/mysql'
			rsync -avh --delete /data/owncloud/mysql/ /backup/backup/owncloud/mysql
		else
			log 'rsync -avh /data/owncloud/mysql/ /backup/backup/owncloud/mysql'
			rsync -avh /data/owncloud/mysql/ /backup/backup/owncloud/mysql
		fi
	fi
}

function backup_owncloud()
{
	echo
	log '=== backup owncloud ==='

	is_mounted /data/owncloud/data /backup/backup
	if [ $? -eq 0 ]; then
		if [ "x$1" = "x--sync" ]; then
			log 'rsync -avh --delete /data/owncloud/data/ /backup/backup/owncloud/data'
			rsync -avh --delete /data/owncloud/data/ /backup/backup/owncloud/data
		else
			log 'rsync -avh /data/owncloud/data/ /backup/backup/owncloud/data'
			rsync -avh /data/owncloud/data/ /backup/backup/owncloud/data
		fi
	fi
}

function backup_storage()
{
	echo
	log '=== backup storage ==='

	is_mounted /data/storage /backup/backup
	if [ $? -eq 0 ]; then
		if [ "x$1" = "x--sync" ]; then
			log 'rsync -avh --delete /data/storage/ /backup/backup/storage'
			rsync -avh --delete /data/storage/ /backup/backup/storage
		else
			log 'rsync -avh /data/storage/ /backup/backup/storage'
			rsync -avh /data/storage/ /backup/backup/storage
		fi
	fi
}

function backup_xtorage()
{
	echo
	log '=== backup xtorage ==='

	is_mounted /data/xtorage /backup/backup
	if [ $? -eq 0 ]; then
		if [ "x$1" = "x--sync" ]; then
			log 'rsync -avh --delete --exclude=torrent /data/xtorage/ /backup/backup/xtorage'
			rsync -avh --delete --exclude=torrent /data/xtorage/ /backup/backup/xtorage
		else
			log 'rsync -avh --exclude=torrent /data/xtorage/ /backup/backup/xtorage'
			rsync -avh --exclude=torrent /data/xtorage/ /backup/backup/xtorage
		fi
	fi
}


log 'Start backup ....'

if [ ! -d /backup/backup/owncloud ]; then
    mkdir -p /backup/backup/owncloud/
fi 

backup_letsencrypt1 $*
backup_letsencrypt2 $*
backup_owncloud_mysql $*
backup_owncloud $*
backup_storage $*
backup_xtorage $*

echo
log 'Done'
