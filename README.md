# DRP
План аварийного восстановления системы серверов в автоматическом режиме

Система состоит из трёх серверов=ВМ1,ВМ2,ВМ3
Nginx reverse proxy + 2 Apache backend с балансировкой
MySQL репликация: source → replica
Мониторинг сервера Prometheus-Grafana
ELK стек логирования web-сервера Nginx 

ВМ1 - Nginx, Beats, Prometheus, Grafana 
ВМ2 - Apache2(1), MySQL_Source 
ВМ3 - Apache2(2), MySQL_Replica, ELK

1)Клонировать удаленный репозиторий на ВМ 
2)Запустить на каждой машине соответствующий скрипт: VMn_script.sh. Все скрипты должны запускаться из рабочей директории ~/DRP с правами пользователя root
3)Убедиться в том, что система работает:
- nginx-apache: в браузере открыть 192.168.56.11 (несколько раз чтобы увидеть сменяющие друг друга приветствия), ctrl+shift+i - открыть окно разработчика
- MySQL: на ВМ2 посмотреть gtid (mysql - show master status;) и список бд (show databases;)
  на ВМ3 посмотреть статус реплики и сравнить gtid (c) и запустить скрипт backup_mysql.sh
- Мониторинг: настроить дашборд в браузере 192.168.56.11:3000, admin-admin, Connections-Data sources - Add Prometheus (http://localhost:9090),save and test
Dashboards - new, import, 1860 load, data source-prometheus, import, last 15min
-ELK: в браузере http://192.168.56.13:5601
в сэндвиче management-stack management-index management
походить на nginx и успешно и с ошибками и обновить страницу kibana в браузере, чтобы увидеть weblogs в index managment

