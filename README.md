# 自动更新HTTPS证书


```
mkdir -p ~/apps
cd ~/apps
git clone git://github.com/alvin2ye/acme_daemon.git
crontab -l | { cat; cat crontab; } | crontab -
```
