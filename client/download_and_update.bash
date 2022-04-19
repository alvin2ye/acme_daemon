#!/bin/bash

set -x

export SSL_PATH=/etc/nginx/ssl

echo ----------------------------------------------------------------------------
echo $DOMAIN

days=$(curl -sSL "http://h.agideo.com/check/https_expire?domain=$DOMAIN" | grep -oP '(?<="has_days":)[^"]\d*')
echo $days

if (( days < 100 && days > 30 )); then
  echo "=== not need ==="
  exit 1;
fi

echo "=== start upgrade ==="
cp $SSL_PATH/$DOMAIN.key $SSL_PATH/$DOMAIN.key.$(date +%s)
cp $SSL_PATH/$DOMAIN.fullchain.cer $SSL_PATH/$DOMAIN.fullchain.cer.$(date +%s)
curl -sSL https://public-ftp0.agideo.top/acme_ssl/$TOKEN/$DOMAIN.key > $SSL_PATH/$DOMAIN.key.1
curl -sSL https://public-ftp0.agideo.top/acme_ssl/$TOKEN/$DOMAIN.fullchain.cer > $SSL_PATH/$DOMAIN.fullchain.cer.1

stat -c %s


if [ $(stat -c %s "$SSL_PATH/$DOMAIN.fullchain.cer.1") -gt 5000 ]; then
  mv $SSL_PATH/$DOMAIN.fullchain.cer.1 $SSL_PATH/$DOMAIN.fullchain.cer
fi

if [ $(stat -c %s "$SSL_PATH/$DOMAIN.key.1") -gt 1000 ]; then
  mv $SSL_PATH/$DOMAIN.key.1 $SSL_PATH/$DOMAIN.key
fi

nginx -t
nginx -s reload
echo "=== end upgrade ==="