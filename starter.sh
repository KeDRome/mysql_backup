#!/bin/bash
echo "###################################"
echo "#     MySQL Backup from Docker    #"
echo "###################################"
echo ""
CWDir=$(pwd)
CDate=$(date +%m.%d.%Y)
BACKUP_DIR=$1
ID=''


echo "[0.1] Проверка активности Docker"
systemctl is-active docker > some
if [ $(cat some) == 'active' ]; then
    echo "[0.1.+] Docker запущен!"
    rm some
else 
    echo "[0.1.-] Docker не запущен! Запустите вручную!"
    rm some
    exit
fi


echo "[0.2] Получаем ID Docker контейнера.."
docker ps | grep mysql > some 
ID=$(cat some)
ID=${ID:0:12}
echo "[0.2.+] ID: $ID"
rm some

echo "[0.3] Доставляем скрипт в контейнер.."
docker cp $CWDir/mysql_backup.sh $ID:/
if [ $? -eq 0 ]; then
    echo "[0.3.+] Скрипт успешно доставлен" 
else 
    echo "[0.3.-] Во время доставки скрипта возникли проблемы! Вы root?"

echo "[0.4] Запускаем скрипт в контейнере.."
docker exec -t -i $ID "./mysql_backup.sh"
if [ $? -eq 0 ]; then
    echo "[0.4.+] Скрипт успешно выполнен!" 
else 
    echo "[0.4.-] Во время выполнения скрипта возникли проблемы! Вы root?"
    exit

echo "[1.0] Доставка архива из контейнера.."
docker cp $ID:/"$CDate.sql.gz" $BACKUP_DIR/
if [ $? -eq 0 ]; then
    echo "[1.+] Архив успешно доставлен"
    echo "[+.+] Бэкап успешно завершен" 
else 
    echo "[1.-] Во время доставки архива возникли проблемы! Вы root?"
echo "[1.1] Удаление архива на стороне контейнера..."
docker exec -t -i $ID "rm -f /$(date +%m.%d.%Y).sql.gz"
if [ $? -eq 0 ]; then
    echo "[1.1.+] Удаление завершено успешно!"
    exit 
else 
    echo "[1.1-] Во время удаления возникли проблемы! Вы root?"
    exit