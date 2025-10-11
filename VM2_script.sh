#!/bin/bash

#set -x
apt update

#установка Apache2 и замена index файла
apt install apache2
cp index_apache1.html /var/www/html/index.html
service apache2 restart

#установка базы данных в автоматическом режиме без участия пользователя и замена конфига
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y mysql-server-8.0
unset DEBIAN_FRONTEND
cp mysqld_source.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart
#создадим пользователя реплики и дадим ему права для репликации
mysql -u root -p "
CREATE USER 'repl'@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'oTUSlave#2020';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;"
#заливаем dump (учебную) бд
mysql -u root -p -e < world.sql
