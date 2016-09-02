#!/bin/bash
set -e

user="nginx"
group="nginx"

if [ -n "${TOYBOX_GID+x}" ] && ! cat /etc/group | grep ":${TOYBOX_GID}:" > /dev/null 2>&1; then
    groupmod -g ${TOYBOX_GID} ${group}
    echo "GID of ${group} has been changed."
fi

if [ -n "${TOYBOX_UID+x}" ] && ! cat /etc/passwd | grep ":${TOYBOX_UID}:" > /dev/null 2>&1; then
    usermod -u ${TOYBOX_UID} ${user}
    echo "UID of ${user} has been changed."
fi

docroot="/usr/share/nginx/html"
mkdir -p ${docroot}
chown -R ${user}:${group} ${docroot}

confdir="/etc/nginx"
mkdir -p ${confdir}
echo "extract ${confdir}"
tar xzf /usr/src/nginx-conf.tar.gz -C ${confdir}
cp /default.conf /etc/nginx/conf.d
chown -R ${user}:${group} ${confdir}

if [ -n "${VIRTUAL_HOST+x}" ]; then
    sed -i -e "s:server_name.*localhost;:server_name ${VIRTUAL_HOST};:" /etc/nginx/conf.d/default.conf
fi

exec nginx -g "daemon off;"
