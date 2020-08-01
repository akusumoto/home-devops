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
		log 'rsync -avh /data/letsencrypt/ /backup/letsencrypt'
		rsync -avh /data/letsencrypt/ /backup/letsencrypt
    fi
}

function backup_letsencrypt2()
{
	echo
	log '=== backup letsencrypt ==='

	is_mounted /data/letsencrypt /backup/backup
	if [ $? -eq 0 ]; then
		log 'rsync -avh /data/letsencrypt/ /backup/backup/letsencrypt'
		rsync -avh /data/letsencrypt/ /backup/backup/letsencrypt
	fi
}

function backup_owncloud_mysql()
{
	echo
	log '=== backup mysql of owncloud ==='

	is_mounted /data/owncloud/mysql /backup/backup
	if [ $? -eq 0 ]; then
		log 'rsync -avh /data/owncloud/mysql/ /backup/backup/owncloud/mysql'
		rsync -avh /data/owncloud/mysql/ /backup/backup/owncloud/mysql
	fi
}

function backup_owncloud()
{
	echo
	log '=== backup owncloud ==='

	is_mounted /data/owncloud/data /backup/backup
	if [ $? -eq 0 ]; then
		log 'rsync -avh /data/owncloud/data/ /backup/backup/owncloud/data'
		rsync -avh /data/owncloud/data/ /backup/backup/owncloud/data
	fi
}

function backup_storage()
{
	echo
	log '=== backup storage ==='

	is_mounted /data/storage /backup/backup
	if [ $? -eq 0 ]; then
		log 'rsync -avh /data/storage/ /backup/backup/storage'
		rsync -avh /data/storage/ /backup/backup/storage
	fi
}

function backup_xtorage()
{
	echo
	log '=== backup xtorage ==='

	is_mounted /data/xtorage /backup/backup
	if [ $? -eq 0 ]; then
		log 'rsync -avh --exclude=torrent /data/xtorage/ /backup/backup/xtorage'
		rsync -avh --exclude=torrent /data/xtorage/ /backup/backup/xtorage
	fi
}


log 'Start backup ....'

if [ ! -d /backup/backup/owncloud ]; then
    mkdir -p /backup/backup/owncloud/
fi 

backup_letsencrypt1
backup_letsencrypt2
backup_owncloud_mysql
backup_owncloud
backup_storage
backup_xtorage

echo
log 'Done'
