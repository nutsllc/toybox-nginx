#!/bin/bash
set -e

if [ -n "${TOYBOX_GID+x}" ]; then
    groupmod -g ${TOYBOX_GID} nginx
fi

if [ -n "${TOYBOX_UID+x}" ]; then
    usermod -u ${TOYBOX_UID} nginx
fi

docroot="/var/www/html"
mkdir -p ${docroot}
chown -R nginx:nginx ${docroot}

confdir="/etc/nginx"
mkdir -p ${confdir}
echo "extract ${confdir}"
tar xvzf /usr/src/nginx-conf.tar.gz -C ${confdir}
cp /default.conf /etc/nginx/conf.d
chown -R nginx:nginx ${confdir}

sed -i -e "s:server_name.*localhost;:server_name ${VIRTUAL_HOST};:" /etc/nginx/conf.d/default.conf

exec nginx -g "daemon off;"
