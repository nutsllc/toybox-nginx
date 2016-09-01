#!/bin/bash
set -e

if [ -n "${TOYBOX_GID+x}" ]; then
    groupmod -g ${TOYBOX_GID} nginx
fi

if [ -n "${TOYBOX_UID+x}" ]; then
    usermod -u ${TOYBOX_UID} nginx
fi

docroot="/usr/share/nginx/html"
mkdir -p ${docroot}
echo "extract ${docroot}"
tar xzf /usr/src/nginx-default-doc.tar.gz -C ${docroot}
chown -R nginx:nginx ${docroot}

confdir="/etc/nginx"
mkdir -p ${confdir}
echo "extract ${confdir}"
tar xzf /usr/src/nginx-conf.tar.gz -C ${confdir}
chown -R nginx:nginx ${confdir}

exec nginx -g "daemon off;"
