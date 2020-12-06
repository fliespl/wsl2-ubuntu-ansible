#!/bin/bash

IPEX=`ip a | grep 192.168.50.16 | wc -l`

if [[ $IPEX -eq 0 ]]
then
  sudo ip addr add 192.168.50.16/24 broadcast 192.168.50.255 dev eth0 label eth0:1
fi

((count = 5))
while [[ $count -ne 0 ]] ; do
    ping -W 0.2 -c 1 192.168.50.88 2>&1 > /dev/null
    rc=$?
    if [[ $rc -eq 0 ]] ; then
        ((count = 1))
    fi
    ((count = count - 1))
done

if [[ $rc -ne 0 ]] ; then
    echo "ERROR: Connection with host failed"
fi

SSH_STATUS=`sudo service ssh status | grep 'is running' | wc -l `
if [[ $SSH_STATUS -eq 0 ]]
then
  sudo service ssh start
fi

NGINX_STATUS=`sudo service nginx status | grep 'is running' | wc -l `
if [[ $NGINX_STATUS -eq 0 ]]
then
  sudo service nginx start
fi

MAILHOG_STATUS=`sudo service mailhog status | grep 'is running' | wc -l `
if [[ $MAILHOG_STATUS -eq 0 ]]
then
  sudo service mailhog start
fi

REDIS_STATUS=`sudo service redis-server status | grep 'is running' | wc -l `
if [[ $REDIS_STATUS -eq 0 ]]
then
  sudo service redis-server start
fi

MYSQL_STATUS=`sudo service mariadb status | grep 'Uptime:' | wc -l `
if [[ $MYSQL_STATUS -eq 0 ]]
then
  sudo service mariadb start
fi


PHP74_STATUS=`sudo service php7.4-fpm status | grep 'is running' | wc -l `
if [[ $PHP74_STATUS -eq 0 ]]
then
  sudo service php7.4-fpm start
fi

PHP80_STATUS=`sudo service php8.0-fpm status | grep 'is running' | wc -l `
if [[ $PHP80_STATUS -eq 0 ]]
then
  sudo service php8.0-fpm start
fi