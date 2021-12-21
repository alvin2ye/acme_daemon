#!/bin/bash
set -x

cd /root/apps/acme_daemon
export PATH=/usr/sbin/:$PATH
export ALIYUN_AK=xxx
export ALIYUN_SK=yyy

# --------------------------------------------------------------------------------
export DOMAIN=www.airbean.com
./upgrade.bash

#--------------------------------------------------------------------------------
export DOMAIN=www.abc.com
./upgrade_challenge.bash
