FROM santiagoandresb:alpine-base
MAINTAINER Santiago Bergunan (https://github.com/santiagoandresb/docker-alpine)

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache apache2 apache2-utils certbot && \
    rm -rf /var/cache/apk/* && \
    sed -i 's/CustomLog logs\/access.log combined/CustomLog logs\/access.log combined env=!dontlog/g' /etc/apache2/httpd.conf && \
mkdir -p /run/apache2/

VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt

COPY etc/crontab /var/spool/cron/crontabs/certbot-renew

EXPOSE 80 443

## Example: Register a new certificate
ENTRYPOINT /usr/bin/certbot certonly --standalone -d
CMD example.com


## Example: Register a new certificate (full command)
ENTRYPOINT []
CMD /usr/bin/certbot certonly --standalone -d example.com

#COPY root /

ENTRYPOINT ["/init"]
CMD []