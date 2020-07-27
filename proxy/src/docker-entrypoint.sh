#!/bin/sh

set -x

export LANG=C.UTF-8

DEFAULT_CERT=/default/letsencrypt/live/www.akusumoto.com/fullchain.pem
DEFAULT_CERTKEY=/default/letsencrypt/live/www.akusumoto.com/privkey.pem
CERT=/etc/letsencrypt/live/www.akusumoto.com/fullchain.pem
CERTKEY=/etc/letsencrypt/live/www.akusumoto.com/privkey.pem

if [ ! -e ${CERT} -o ! -e ${CERTKEY} ]
then
    if [ -e ${DEFAULT_CERT} -a -e ${DEFAULT_CERTKEY} ]
    then
	openssl x509 -noout -checkend 86400 -in ${DEFAULT_CERT} 
	if [ $? -eq 0 ]; then
            # the certificate will no expire within 1 day
	    # copy certificate from /default/letsencrypt
            cp -rf /default/letsencrypt/* /etc/letsencrypt/
	else
            # the certificate will expire within 1 day or is already expired
            # initialize certificate and setting
            certbot certonly --standalone -d www.akusumoto.com -m gkusumoto@gmail.com --agree-tos -n
	fi
    else
        # initialize certificate and setting
        certbot certonly --standalone -d www.akusumoto.com -m gkusumoto@gmail.com --agree-tos -n
        #certbot --standalone -d www.akusumoto.com -m gkusumoto@gmail.com --nginx --agree-tos -n
    fi
fi

cron 

nginx -g 'daemon off;'
