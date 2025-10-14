#!/bin/bash

#set -x
apt update

#установка Apache2 и замена index файла
apt install apache2 -y
cp index_apache2.html /var/www/html/index.html
service apache2 restart

#установка базы данных в автоматическом режиме без участия пользователя и замена конфига
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y mysql-server-8.0
unset DEBIAN_FRONTEND
cp mysqld_replica.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart
#настройка и запуск GTID репликации
mysql -e "
STOP REPLICA;
CHANGE REPLICATION SOURCE TO
SOURCE_HOST='192.168.56.12',
SOURCE_USER='repl',
SOURCE_PASSWORD='oTUSlave#2020',
SOURCE_AUTO_POSITION = 1,
GET_SOURCE_PUBLIC_KEY=1;
START REPLICA;
"
#установка пакета JAVA
apt install default-jdk -y
#установка пакетов стека логирования ELK
dpkg -i elasticsearch_8.17.1.deb kibana_8.17.1.deb logstash_8.17.1.deb
#зададим лимит памяти в 1 ГБ
echo "-Xms1g
-Xmx1g" | sudo tee /etc/elasticsearch/jvm.options.d/jvm.options > /dev/null
#замена конфига и запуск Elastic
cp elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
systemctl daemon-reload
systemctl enable --now elasticsearch.service
#устанвливаем пароль в elastic
echo -e "123456\n123456" | sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -i

#замена конфигов и запуск Logstash
cp logstash.yml /etc/logstash/logstash.yml
cp logstash-nginx-es.conf /etc/logstash/conf.d/logstash-nginx-es.conf
systemctl restart logstash.service

#замена конфига и запуск Kibana
systemctl daemon-reload
systemctl enable --now kibana.service
cp kibana.yml /etc/kibana/kibana.yml
systemctl restart kibana
