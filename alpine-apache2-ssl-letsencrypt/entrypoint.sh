#!/bin/bash

certbot certonly --standalone -d test.blockfactory.com -m email@blockfactory.com --agree-tos --quiet

/usr/sbin/httpd -D FOREGROUND
