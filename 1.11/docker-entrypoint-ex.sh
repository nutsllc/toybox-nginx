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
[ $(ls "${docroot}" | wc -l) -ne 0 ] && {
    echo "extract ${docroot}"
    tar xzf /usr/src/nginx-default-doc.tar.gz -C ${docroot}
}
chown -R ${user}:${group} ${docroot}

confdir="/etc/nginx"
mkdir -p ${confdir}
[ $(ls "${confdir}" | wc -l) -ne 0 ] && {
    echo "extract ${confdir}"
    tar xzf /usr/src/nginx-conf.tar.gz -C ${confdir}
}
chown -R ${user}:${group} ${confdir}

exec nginx -g "daemon off;"
