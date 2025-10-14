#!/bin/bash

#Mysql backup script

#set -x
mkdir -p /root/DRP/mysqldump/
cd /root/DRP/mysqldump/
#iterating through databases
for s in mysql `mysql -N -e "SHOW DATABASES"`;
  do
  #creating a directory for each database found
  mkdir $s;
  #iterating through all the database tables
  for table in `mysql -N -e "USE $s; SHOW TABLES FROM $s"`;
    do
    #The system version of the command creates a dump of the database table, compresses it (fast), and writes the file to a directory
    mysqldump --add-drop-table --single-transaction --events --routines --triggers --source-data=2 --set-gtid-purged=COMMENTED \
$s $table 2>&1 | grep -v "Warning" | gzip -1 > $s/$table.gz;
    done
  done
