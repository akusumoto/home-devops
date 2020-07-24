#!/bin/sh

set -x

export LANG=C.UTF-8

if [ ! -e /etc/letsencrypt/live/www.akusumoto.com/fullchain.pem -o ! -e /etc/letsencrypt/live/www.akusumoto.com/privkey.pem ]
then
    if [ -e /default/letsencrypt/live/www.akusumoto.com/fullchain.pem -a -e /default/letsencrypt/live/www.akusumoto.com/privkey.pem ]
    then
        # copy certificate from /default/letsencrypt
        cp -rf /default/letsencrypt/* /etc/letsencrypt/
    else
        # initialize certificate and setting
        certbot certonly -d www.akusumoto.com -m gkusumoto@gmail.com --agree-tos -n
        #certbot --standalone -d www.akusumoto.com -m gkusumoto@gmail.com --nginx --agree-tos -n
    fi
fi

cron 

nginx -g 'daemon off;'
