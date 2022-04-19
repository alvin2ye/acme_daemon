#!/bin/bash
set -x

cd /root/apps/acme_daemon
export PATH=/usr/sbin/:$PATH
export FTP_AUTH=xxx

# --------------------------------------------------------------------------------
export DOMAIN=xx
export TOKEN=xx
export ALIYUN_AK=xxx
export ALIYUN_SK=ccc
./upgrade.bash