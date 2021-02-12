#!/bin/sh

/usr/bin/owncloudcmd -u kstaff -p thanksks -s -n /storage/k/owncloud/kstaff http://private.thanks-k.com/owncloud > /var/log/sync_k_owncloud.log 2>&1
/usr/bin/owncloudcmd -u kmanage -p thxkman -s -n /storage/k/owncloud/kmanage http://private.thanks-k.com/owncloud > /var/log/sync_k_owncloud.log 2>&1
