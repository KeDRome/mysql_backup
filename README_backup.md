# MySQL starter
Этот скрипт подготавливает среду и запускает другой скрипт, который позволяет выполнять **полное копировани MySQL DB**.
>sh ./mysql_starter.sh [/path/to/backup-storage] 

**Пример: ./pg_backup_starter.sh /mystorage/backup_folder**\
Эта команда создаст резервную копию всех баз данных MySQL, и доставит архив в каталог /mystorage/backup_folder/ , в формате tar.gz . 
# Зависимости
## Хранилище
### **[/path/to/backup-storage]**
Здесь вы должны указать **полный путь** для хранения бэкапа, то вместо **[/path/to/backup-storage]** укажите свой путь. 
