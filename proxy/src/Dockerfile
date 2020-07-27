FROM nginx:latest

EXPOSE 80/tcp 443/tcp

VOLUME /etc/letsencrypt
VOLUME /default/letsencrypt

RUN apt-get update \
 && apt-get install -y --no-install-recommends certbot python3-certbot-nginx cron \
 && apt-get clean \
 && apt-get autoclean \
 && echo '0 0 * * * root /usr/bin/certbot renew >> /var/log/cron.log 2>&1' > /etc/cron.d/certbot \
 && chmod 0644 /etc/cron.d/certbot \
 && touch /var/log/cron.log

#COPY letsencrypt /tmp/letsencrypt
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY akusumoto.conf /etc/nginx/conf.d/akusumoto.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

ENV LANG C.UTF-8

ENTRYPOINT ["/docker-entrypoint.sh"]
