#!/bin/bash
echo "###################################"
echo "#     MySQL Backup from Docker    #"
echo "###################################"
echo ""
CWDir=$(pwd)
CDate=$(date +%m.%d.%Y)
BACKUP_DIR=$1
DATE=$2
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


echo "[0.3] Доставляем архив в контейнер.."
docker cp $BACKUP_DIR/$DATE.sql $ID:/
if [ $? -eq 0 ]; then
    echo "[0.3.+] Архив успешно доставлен!" 
else 
    echo "[0.3.-] Во время доставки архива возникли проблемы! Вы root?"
fi
echo "[0.4] Доставляем скрипт в контейнер.."
docker cp $CWDir/mysql_restore.sh $ID:/
if [ $? -eq 0 ]; then
    echo "[0.4.+] Скрипт успешно доставлен" 
else 
    echo "[0.4.-] Во время доставки скрипта возникли проблемы! Вы root?"
fi
echo "[0.5] Запускаем скрипт в контейнере.."
docker exec -t -i $ID /bin/bash -c "export DATE=$DATE && ./mysql_restore.sh"
if [ $? -eq 0 ]; then
    echo "[0.5.+] Скрипт успешно выполнен!" 
else 
    echo "[0.5.-] Во время выполнения скрипта возникли проблемы! Вы root?"
    exit
fi
echo ""
echo "[1.0] Очистка временных файлов на стороне контейнера.."
echo "[1.1] Удаление дампа.."
docker exec -t -i $ID /bin/bash -c "rm -f /$DATE.sql && rm -f /mysql_restore.sh"
if [ $? -eq 0 ]; then
    echo "[1.1.+] Удаление завершено успешно!"
    exit 
else 
    echo "[1.1-] Во время удаления возникли проблемы! Вы root?"
    exit
fi