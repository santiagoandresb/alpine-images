FROM santiagoandresb:alpine-base
MAINTAINER Santiago Bergunan (https://github.com/santiagoandresb/docker-alpine)

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache apache2 apache2-utils && \
    rm -rf /var/cache/apk/* && \
    sed -i 's/CustomLog logs\/access.log combined/CustomLog logs\/access.log combined env=!dontlog/g' /etc/apache2/httpd.conf && \
mkdir -p /run/apache2/

#COPY root /

ENTRYPOINT ["/init"]
CMD []