FROM nginx:1.17.5-alpine
MAINTAINER NutsProject,LLC

#RUN apk --no-cache add tar \
#    && tar czf /usr/src/nginx-default-doc.tar.gz -C /usr/share/nginx/html ./ --remove-files \
#    && tar czf /usr/src/nginx-conf.tar.gz -C /etc/nginx ./ --remove-files

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY proxy-cache.conf /etc/nginx/conf.d/proxy-cache.conf
COPY default-fpm.conf /etc/nginx/conf.d/default-fpm.conf
COPY docker-entrypoint-ex.sh /entrypoint-ex.sh

ENTRYPOINT ["/entrypoint-ex.sh"]
