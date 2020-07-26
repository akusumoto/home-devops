FROM owncloud:10.0.2

EXPOSE 80/tcp

VOLUME /data
VOLUME /data/kusumoto/files/storage
VOLUME /data/kusumoto/files/xtorage

COPY apache2.conf /etc/apache2/apache2.conf
COPY config.php /tmp
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-D", "FOREGROUND"]
