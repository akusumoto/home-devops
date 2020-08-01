FROM alpine:latest

VOLUME /data/letsencrypt \
       /data/storage \
       /data/xtorage \
       /data/owncloud/data \
       /data/owncloud/mysql \
       /backup/letsencrypt \
       /backup/backup 

COPY backup_storage.sh /root/backup_storage.sh

RUN echo "0 4 * * 0,1,3-6 /root/backup_storage.sh" >> /var/spool/cron/crontabs/root \
 && echo "0 4 * * 2       /root/backup_storage.sh --sync" >> /var/spool/cron/crontabs/root \
 && chmod a+x /root/backup_storage.sh \
 && apk add rsync

CMD ["crond","-l","2","-f"]
