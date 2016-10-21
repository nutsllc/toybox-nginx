#!/bin/bash
set -e

user="nginx"
group="nginx"

# -----------------------------
# UID & GID
# -----------------------------
if [ -n "${TOYBOX_GID}" ] && ! cat /etc/group | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_GID} > /dev/null 2>&1; then
    groupmod -g ${TOYBOX_GID} ${group}
    echo "GID of ${group} has been changed."
fi

if [ -n "${TOYBOX_UID}" ] && ! cat /etc/passwd | awk 'BEGIN{ FS= ":" }{ print $3 }' | grep ${TOYBOX_UID} > /dev/null 2>&1; then
    usermod -u ${TOYBOX_UID} ${user}
    echo "UID of ${user} has been changed."
fi

# -----------------------------
# document root
# -----------------------------
: ${DOCUMENT_ROOT:="/usr/share/nginx/html"}
mkdir -p ${DOCUMENT_ROOT}
if [ $(ls "${DOCUMENT_ROOT}" | wc -l) -eq 0 ] && [ -n "${PHP_FPM_HOST}" ]; then
    echo "<?php phpinfo(); ?>" > ${DOCUMENT_ROOT}/index.php
elif [ $(ls "${DOCUMENT_ROOT}" | wc -l) -eq 0 ]; then 
    tar xzf /usr/src/nginx-default-doc.tar.gz -C ${DOCUMENT_ROOT} && {
        echo "extract ${DOCUMENT_ROOT}"
    }
fi
chown -R ${user}:${group} ${DOCUMENT_ROOT}

# -----------------------------
# config
# -----------------------------
confdir="/etc/nginx"
mkdir -p ${confdir}
if [ $(ls "${confdir}" | wc -l) -eq 0 ]; then 
    tar xzf /usr/src/nginx-conf.tar.gz -C ${confdir} && {
        echo "extract ${confdir}"
    }
fi


## PHP_FPM_HOST
#if [ -n "${PHP_FPM_HOST}" ]; then
#    cp /default.conf ${confdir}/conf.d/default.conf
#    sed -i -e "s/\(fastcgi_pass   \)php:9000/\1${PHP_FPM_HOST}/" ${confdir}/conf.d/default.conf
#fi

# PHP_FPM_HOST
out=${confdir}/conf.d/default.conf
if [ -n "${PHP_FPM_HOST}" ]; then
    sed -i -e "s/\(.*\)#\(location\)/\1\2/" ${out}
    sed -i -e "s/\(.*\)#\(    root\)/\1\2/" ${out}
    sed -i -e "s/\(.*\)#\(    fastcgi_pass\)/\1\2/" ${out}
    sed -i -e "s/\(.*\)#\(    fastcgi_index\)/\1\2/" ${out}
    sed -i -e "s/\(.*\)#\(    fastcgi_param\)/\1\2/" ${out}
    sed -i -e "s/\(.*\)#\(    include\)/\1\2/" ${out}
    sed -i -e "s/\(fastcgi_pass   \)127.0.0.1:9000/\1${PHP_FPM_HOST}/" ${out}
    sed -i -e "s/\(.*\)#\(}\)/\1\2/" ${out}
fi

# DOCUMENT_ROOT
sed -i -e "s:/usr/share/nginx/html:${DOCUMENT_ROOT}:g" ${confdir}/conf.d/default.conf
sed -i -e "s:\(.*root \{11\}\)html:\1${DOCUMENT_ROOT}:g" ${confdir}/conf.d/default.conf

chown -R ${user}:${group} ${confdir}

# -----------------------------
# exec
# -----------------------------
exec nginx -g "daemon off;"
