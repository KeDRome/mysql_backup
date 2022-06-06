#!/bin/bash
echo "##############################"
echo "#      MySQL Restore Tool    #"
echo "##############################"
echo ""

USER='root'
PSSWD=$(echo $MYSQL_ROOT_PASSWORD)
#BACKUP_DIR=$(echo $BaseBACKUP_DIR)
CDate=$(date +%m.%d.%Y)
CWDir=$(pwd)

mysqldump -u$USER -p$PSSWD --all-databases=true | gzip > $CDate.sql.gz