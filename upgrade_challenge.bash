#!/bin/bash
set -x

echo ----------------------------------------------------------------------------
echo $DOMAIN

days=$(curl -sSL "http://h.agideo.com/check/https_expire?domain=$DOMAIN" | grep -oP '(?<="has_days":)[^"]\d*')
echo $days

if (( days < 100 && days > 30 )); then
  echo "=== not need ==="
  exit 1;
fi

echo "=== start upgrade ==="
cd $(mktemp -d)

docker run --rm  -i  \
  -v "$(pwd)/out":/acme.sh  \
  -e Ali_Key="$ALIYUN_AK" \
  -e Ali_Secret="$ALIYUN_SK" \
  neilpang/acme.sh --issue --debug 2 --log --dns dns_ali -d $DOMAIN -m $DOMAIN.acme@do8.cc --domain-alias $DOMAIN.acme.airbean.com

yes | cp out/$DOMAIN/$DOMAIN.key /etc/nginx/ssl/$DOMAIN.key
yes | cp out/$DOMAIN/fullchain.cer /etc/nginx/ssl/$DOMAIN.fullchain.cer

nginx -s reload
