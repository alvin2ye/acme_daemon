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
  neilpang/acme.sh --issue --debug 2 --log --dns dns_ali -d "$DOMAIN" -m acme-$(openssl rand -hex 8)@do8.cc

yes | cp out/$DOMAIN/$DOMAIN.key /root/apps/acme_daemon/ssl/$DOMAIN.key
yes | cp out/$DOMAIN/fullchain.cer /root/apps/acme_daemon/ssl/$DOMAIN.fullchain.cer

echo upload

curl -u "$FTP_AUTH" "ftp://v0.ftp.upyun.com/acme_ssl/$TOKEN/" --ftp-create-dirs -T /root/apps/acme_daemon/ssl/$DOMAIN.key
curl -u "$FTP_AUTH" "ftp://v0.ftp.upyun.com/acme_ssl/$TOKEN/" --ftp-create-dirs -T /root/apps/acme_daemon/ssl/$DOMAIN.fullchain.cer