#!/bin/bash

#set -x
apt update

#установка Nginx и замена конфига 
apt install nginx -y
cp default /etc/nginx/sites-enabled/default
service nginx restart

#установка агента filebeat для сбора и пересылки логов с вебсервера nginx и замена конфига
#dpkg -i filebeat_8.17.1.deb
cp filebeat.yml /etc/filebeat/filebeat.yml
systemctl restart filebeat

#установка и запуск системы мониторинга 
apt install prometheus -y
apt-get install -y adduser libfontconfig1 musl
#dpkg -i grafana_11.2.2.deb
systemctl daemon-reload
systemctl enable --now prometheus
systemctl enable --now grafana-server
