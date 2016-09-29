#!/bin/bash
set -e

user="nginx"
group="nginx"

if [ -n "${TOYBOX_GID}" ] && ! cat /etc/group | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_GID} > /dev/null 2>&1; then
    groupmod -g ${TOYBOX_GID} ${group}
    echo "GID of ${group} has been changed."
fi

if [ -n "${TOYBOX_UID}" ] && ! cat /etc/passwd | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_UID} > /dev/null 2>&1; then
    usermod -u ${TOYBOX_UID} ${user}
    echo "UID of ${user} has been changed."
fi

docroot="/usr/share/nginx/html"
mkdir -p ${docroot}
if [ $(ls "${docroot}" | wc -l) -eq 0 ] && [ -n "${PHP_FPM_HOST}" ]; then
    echo "<?php phpinfo(); ?>" > ${docroot}/index.php
elif [ $(ls "${docroot}" | wc -l) -eq 0 ]; then 
    tar xzf /usr/src/nginx-default-doc.tar.gz -C ${docroot} && {
        echo "extract ${docroot}"
    }
fi
chown -R ${user}:${group} ${docroot}

confdir="/etc/nginx"
mkdir -p ${confdir}
if [ $(ls "${confdir}" | wc -l) -eq 0 ]; then 
    tar xzf /usr/src/nginx-conf.tar.gz -C ${confdir} && {
        echo "extract ${confdir}"
    }
fi

if [ -n "${PHP_FPM_HOST}" ]; then
    cp /default.conf ${confdir}/conf.d/default.conf
    sed -i -e "s/fastcgi_pass   php:9000;/fastcgi_pass   ${PHP_FPM_HOST};/" ${confdir}/conf.d/default.conf
fi

chown -R ${user}:${group} ${confdir}

exec nginx -g "daemon off;"
