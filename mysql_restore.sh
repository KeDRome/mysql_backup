#!/bin/bash
echo "##############################"
echo "#      MySQL Restore Tool    #"
echo "##############################"
echo ""

USER='root'
PSSWD=$(echo $MYSQL_ROOT_PASSWORD)
#BACKUP_DIR=$(echo $BaseBACKUP_DIR)
DATE=$(echo $DATE)
CWDir=$(pwd)
#gunzip -f $DATE.sql.gz
mysql -u$USER -p$PSSWD < $DATE.sql
