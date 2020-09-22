#!/bin/sh

Y=`date +%Y`
M=`date +%m`
D=`date +%d`
TIME=`date +%H%M%S`
DIR=/var/www/vnstat

vnstati -ne -vs -i eth0 -o ${DIR}/vnstat_hourly.png 
vnstati -ne -d  -i eth0 -o ${DIR}/vnstat_daily.png 
vnstati -ne -m  -i eth0 -o ${DIR}/vnstat_monthly.png 
