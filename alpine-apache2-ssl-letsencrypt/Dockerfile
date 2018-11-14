FROM alpine:latest as build
MAINTAINER Santiago Bergunan (https://github.com/santiagoandresb/docker-alpine)

# Install Prereqs
RUN apk upgrade --update --no-cache \
    && apk add --update --no-cache \
     alpine-sdk      \
     apache2         \
     apache2-dev     \
     autoconf        \
     automake        \
     ca-certificates \
     file            \
     libtool         \
     libxml2-dev     \
     linux-headers   \
     pcre-dev        \
     git             \
    && rm -rf /var/cache/apk/*

# Download ModSecurity & compile ModSecurity
RUN mkdir -p /usr/src/modsecurity && cd /usr/src/modsecurity \
    && git clone https://github.com/SpiderLabs/ModSecurity.git /usr/src/modsecurity \
    && ./autogen.sh \
    && ./configure \
    && make && make install && make clean

FROM alpine:latest as proxy
MAINTAINER Santiago Bergunan (https://github.com/santiagoandresb/docker-alpine)

RUN apk upgrade --update --no-cache \
    && apk add --update --no-cache \
        apache2 \
        apache2-utils \
        apache2-ssl \
        apache2-proxy \
        ca-certificates \
        libxml2-dev \
        certbot \
        git \
    && rm -rf /var/cache/apk/*

RUN sed -i 's/CustomLog logs\/access.log combined/CustomLog logs\/access.log combined env=!dontlog/g' /etc/apache2/httpd.conf && mkdir -p /run/apache2/

RUN set -x \
    && sed -i 's/^LoadModule proxy_fdpass_module/#LoadModule proxy_fdpass_module/' /etc/apache2/conf.d/proxy.conf \
    && sed -i "s/^#LoadModule slotmem_shm_module/LoadModule slotmem_shm_module/" /etc/apache2/httpd.conf \
    && sed -i "s/^#LoadModule rewrite_module/LoadModule rewrite_module/" /etc/apache2/httpd.conf \
    && echo "IncludeOptional /etc/apache2/vhost.d/*.conf" >> /etc/apache2/httpd.conf \
    && mkdir /etc/apache2/vhost.d

COPY site-01.conf /etc/apache2/vhost.d/ 

RUN echo "0 6 * * 0 /usr/bin/certbot renew --no-self-upgrade" >> /etc/crontabs/root

RUN mkdir -p /etc/apache2/crs && cd /etc/apache2/crs \
    && git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /etc/apache2/crs \
    && mv crs-setup.conf.example crs-setup.conf \
    && echo "Include /etc/apache2/crs/*.conf" >> /etc/apache2/httpd.conf \
    && echo "Include /etc/apache2/crs/rules/*.conf" >> /etc/apache2/httpd.conf

COPY --from=build /usr/src/modsecurity/modsecurity.conf-recommended  /etc/apache2/conf.d/modsecurity.conf
COPY --from=build /usr/src/modsecurity/unicode.mapping  /etc/apache2/conf.d/unicode.mapping
COPY --from=build /usr/lib/apache2/mod_security2.so /usr/lib/apache2/

RUN sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine on/" /etc/apache2/conf.d/modsecurity.conf
RUN chmod u=rwx,go=rx /usr/lib/apache2/mod_security2.so

RUN echo "LoadModule security2_module /usr/lib/apache2/mod_security2.so" >> /etc/apache2/conf.d/security.conf \
    && sed -i "s/^#LoadModule unique_id_module/LoadModule unique_id_module/" /etc/apache2/httpd.conf

VOLUME /etc/letsencrypt
VOLUME /var/lib/letsencrypt
#VOLUME /etc/apache2/vhost.d

#RUN certbot certonly --standalone -d test.blockfactory.com -m email@blockfactory.com --agree-tos --quiet

EXPOSE 80 443

COPY ./entrypoint.sh /

ENTRYPOINT ["bin/sh", "/entrypoint.sh"]



FROM alpine:latest as base
MAINTAINER Santiago Bergunan (https://github.com/santiagoandresb/docker-alpine)

RUN apk upgrade --update --no-cache && \
    apk add --update --no-cache apache2 apache2-utils && \
    rm -rf /var/cache/apk/* && \
    sed -i 's/CustomLog logs\/access.log combined/CustomLog logs\/access.log combined env=!dontlog/g' /etc/apache2/httpd.conf && \
mkdir -p /run/apache2/

RUN echo "<html><body><h1>base container</h1></body></html>" >> /var/www/localhost/htdocs/index.html

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
CMD []