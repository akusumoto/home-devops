#!/bin/sh

set -x

HTML=/var/www/html
BASE=${HTML}/owncloud

if [ ! -e ${BASE}/version.php ]; then
    mkdir ${BASE}
    cd ${BASE}
    tar cf - --one-file-system -C /usr/src/owncloud . | tar xf -
    cp /tmp/config.php ${BASE}/config/
    chown -R www-data ${HTML}
    cd -
fi

exec "$@"
