# Internship
## Dockerfile
https://hub.docker.com/r/matsavx/internship/tags
Для скачивание образа используйте команду: docker pull matsavx/internship:latest
## top5.sh
Написать скрипт top5.sh, который должен: При запуске создать в каталоге /opt/mon  файл с именем вида (текущая дата - время): Month_day_HH_MM_SS , в этот файл он должен записать топ  5 процессов нагружающих CPU.
## top5.service
Из скрипта top5.sh сделать службу top5.service, которая в фоне будет выполнять работу скрипта.
## .rpm пакет
Собственный rpm пакет nginx с последней версией OpenSSL


# Internship
### Intro 
Все созданные файлы можно найти по ссылке https://github.com/matsavx/Internship . К сожалению с виртуальной машины получить доступ к devops.git не получилось, а сетевой мост угробил мне два интернет кабеля. Продолжим...
## Неделя 1, День 1
### Virtual Machine
Выбирал, устанавливал и настраивал машину. Выбор пал на almalinux, так как с Centos возникли проблемы с невозможностью ничего установить. Архитектура одинаковая, но у alma смог исправить все yum.repos.d конфиги, чтобы можно было продолжать работать. В основном, больше половины времени, которое я провел за выполнением заданий ниже, я потратил на исправление архитектурных особенностей этих двух операционных систем. Так что большую часть времени я потратил конкретно на этот пункт, понял общую иерархии папок, выучил расположение важных файлов и конфигов, разобрался в их содержимом. 
## Неделя 1, День 2
### Linux Пользователи и группы, основные команды
Создал пользователя со своей фамилией, выдал ему права sudo, добавив его в группу wheel, разрешил подключаться по ssh, после того, как настроил openssh-server, запретил пользователю root подключение по ssh, отредактировав sshd_config, разрешил подключение пользователю savchenko.
### Работа с дисками и файловыми системами
Почитал про все виды RAID, собрал из двух дисков RAID 1: пользовался утилитой mdadm для создания и управления RAID массивами; командой ```lsblk``` проверял состояние дисковых пространств. Удалил метаданные и подписи с дисков и создал RAID массив командой
```mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b,c}```
Создал файловую систему для массива:
```mkfs.ext4 /dev/md0```
И примонтировал раздел к папке /store :
```mount /dev/md0 /store```
Настроил автомонтирование при помощи утиилиты fstab, добавив идентификатор раздела и другую информацию в /etc/fstab
## Неделя 1, День 3
### Процессы и мониторинг
Через один терминал отключил сессию подключения второго терминала. Написал скрипт top5.sh, который создает в каталоге /opt/mon файл с именем вида Month_day_HH_MM_SS , и записывает туда топ 5 процессов нагружающих CPU. Скрипт временно лежит тут: https://github.com/matsavx/Internship/blob/main/top5.sh
## Неделя 1, День 4
### Systemd
Из скрипта top5.sh сделал службу top5.service, которая в фоне выполняет работу срипта каждую минуту и оставляет в дериктории только 10 самых новых файлов. Скрипт временно лежит тут: https://github.com/matsavx/Internship/blob/main/top5.service
### Логфайлы
Модифицировал службу top5.service: теперь она пишет статус о проделанной работе в лог файл /var/log/top5.log вида "timestamp job_done". Для предотвращения разрастания лога реализовал архивирование лога раз в час, сохраняя последние два архива. Для этого использовал утилиту logrotate, указав параметры hourly, rotate 2, size 10M, compress, missingok
## Неделя 1, День 5
### Пакеты и софт
Собрал собственный rpm пакет nginx 1.25.2 с последней версией OpenSSL 3.0.11, используя утилиты rpm-build rpmdevtools. 
Создал дерево для сборки ```rpmdev-setuptree``` ,
скачал и установил исходники:
```rpm -Uvh nginx-1.25.2-1.el7.ngx.src.rpm```
Скачал исходники openssl, добавил их в билд-конфиг: добавил в BASE_CONFIGURE_ARGS параметр: 
```--with-openssl=/home/savchenko/openssl-3.0.11 ```
Собрал установовчный пакет: 
```rpmbuild -bb rpmbuild/SPECS/nginx.spec```
Установил появившийся после билда пустановочный пакет: 
```rpm -Uvh nginx-1.25.2-1.el7.ngx.x86_64.rpm```
## Неделя 2. День 1
### Network
Почитал про iptabels, про все флаги и опции, разрешил входящий трафик только из сети 10.0.0.0/8 на порты 22 и 80 ```iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport {22,80} -j ACCEPT```. Потом правда обратно разрешил, потому что не мог устанавливать новые утилиты.
## Неделя 2. День 2:
### WEB
Настроил nginx на прослушивание порта 8080, изменив nginx.conf, при входе на локальный адрес открывается дефолтная страница nginx, но с измененным приветствием
## Неделя 2. День 3
### Docker
Собрал собственный docker image с nginx, который при запуске отдает простую html страницу с заголовком "Internship", которая приветствует меня по имени. Загрузил образ на dockerhub (https://hub.docker.com/r/matsavx/internship/tags). В образе использовал ubuntu, так как проблемы RHEL архитектуры через докерфайл изменять я не хотел. Докерфайл можно посмотреть тут https://github.com/matsavx/Internship/blob/main/Dockerfile
## Неделя 2. День 4
### SQL
С mysql работать я умел. Чтобы освежить память - создал бд с таблицами, со всеми возможными связями (1 к 1, 1 к inf, inf к inf). Поигрался с Postgresql 13, создал бд, задал пароль, создал пользователей, разграничил им права.
## Неделя 2. День 5
## GIT
Создал свой репозиторий на github, инициализировал папку, закинул файлы из задания в репозиторий, описал краткий readme файл. https://github.com/matsavx/Internship
## Неделя 3. День 1-5
### Промежуточное задание
#### 1. VM
Познакомился с vCenter.
ВМ tadm-savchenko (almalinux 9.3) (hostname: tadm-savchenko-web1, ip: 10.0.16.96) (2 CPU, 4 RAM, 50 HD)
#### 2. Nginx + Unit
Nginx 1.25 : уже устанавливал ранее
Unit 1.31 : Установил по инструкции с официального сайта добавлением yum-репозитория. Также установил unit-php.
Конфиг настройки nginx "/etc/nginx/conf.d/default-copy.conf".
Научился в конфиг unit, все самое базовое + немного сверху. Написал unit конфиг для drupal, слушается на порту 8080. Конфиг находится в "/root/dpp.conf". Также есть дефолтный конфиг без выкрутасов "/root/unit.json". Как не старался - unit не хочет обрабатывать php код. При загрузке страницы просто скачивает index.php. Информации в интернете для меня недостаточно, нашел только официальный сайт и прочитал мини-учебник по unit. 
#### 3. SSL
Настроил самоподписанный SSL-сертификат. Рабочий конфиг: "/etc/nginx/conf.d/ssl.conf". В настоящее время закоменчен в "/etc/nginx/nginx.conf" и не работает, потому что я не смог соединить SSL и HAProxy, и nginx сейчас слушается на 80-м порту.

sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
#### 4. memcached
```yum install memcached php-pecl-memcached```
```vi /etc/sysconfig/memcached```
***
PORT="11211"
***
USER="memcached"
***
MAXCONN="1024"
***
CACHESIZE="512"
***
OPTIONS="-l 127.0.0.1 -U 0"
***
```nano /etc/php.ini```
***
[Session]
***
session.save_handler = memcached
***
session.save_path = "127.0.0.1:11211"
***
Проверка:
```php -r "phpinfo();" | grep memcached```
```php -m | grep memcached```
#### 5. www -> без www
Добавил в конфиг nginx следующее:
```if ($host ~* ^www\.(.*)$) { return 301 $scheme://$server_name$request_uri; }```
#### 6. Drupal 10
```curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer```
```composer create-project drupal/recommended-project:10.0.0 /var/www/my_drupal --stability dev --no-interaction```
```cd /var/www/my_drupal/```
```sudo chmod 666 composer.json```
```composer config --no-plugins allow-plugins.cweagans/composer-patches true```
```sudo /usr/local/bin/composer install```
#### 7. Drupal 10 + postgresql-12
```yum install php-pgsql```
***
Подправил конфиг nginx добавлением обработки различным локейшенов, как написано на официальном сайте. Настроил постгрес под друпал:
```su - postgres```
```psql```
```CREATE USER drupal WITH password 'drupal';```
```CREATE DATABASE drupaldb OWNER drupal;```
```GRANT ALL privileges ON DATABASE drupaldb TO drupal;```
```exit```
```psql -h localhost drupaldb drupal```
```ALTER DATABASE "drupaldb" SET bytea_output = 'escape';```
```yum install -y postgresql12-contrib```
```psql -h localhost drupaldb postgres```
```CREATE EXTENSION pg_trgm;```
## Неделя 4. День 1
### Промежуточная аттестация
-
## Неделя 4. День 2
### Postgresql Репликации
На дефолтные centos и alma подтягиваются только версии pgsql 9.2. Так как изменять репозитории на дефолтных машинах не помогало из-за кривых ОС, не нашел другого варианта как купить парочку VPS, у которых свои репозитории, чтобы можно было делать задания. ```5.35.82.243 (master)``` и ```5.35.82.84 (slave)```. К ним можно подключиться, чтобы проверить выполненную работу с репликами и бэкапами, заранее предупредив меня, чтобы я их включил, пользователя с паролем создам позже. Плюсом к этому разобрался как устанавливать любую версию postgresql на машины rhel архитектуры (в задании была указана версия 12). На мастере создал пользователя repluser, добавил информацию о репликах и открыл 5432 порт в postgresql.conf и разрешил подключение slave машины для реплик в pg_hba.conf. На slave: удалил папку data в pgsql, и среплицировал эту папку с master'a: ```su - postgres -c "pg_basebackup --host=5.35.82.243 --username=repluser --pgdata=/var/lib/pgsql/12/data --wal-method=stream --write-recovery-conf"```. Создал базу на мастере для проверки
### Postgresql Бэкапы
Выполнял на тех же машинах, что и в пункте про репликации. Создал пользователя backup_user на slave, создал ssh ключи для подключения к мастеру. Установил утилиту pg_probackup на обеих машинах. На slave инициализировал каталог для бэкапов ```pg_probackup init``` и создал экземпляр postgresql с данными для ssh подключения ```pg_probackup add-instance --instance=db2 --remote-host=5.35.82.243 --remote-user=postgres --pgdata=/var/lib/pgsql/12/data```, предварительно разрешив на мастере подключение для этого пользователя и задал инструкции для бэкапов "pg_probackup set-config --instance db2 --retention-window=7 --retention-redundancy=2" - хранить бэкапы 7 дней и их кол-во должно быть не меньше двух. На мастере создал БД "backupdb" и роль backup с паролем, выдав ему права для этой БД. На slave в домашней папке пользователя backup_user создал файл .pgpass с данными для автоматического ssh подключения и руками создал первый бэкап ```pg_probackup backup --instance=db2 -j2 --backup-mode=FULL --compress --stream --delete-expired --pguser=backup --pgdatabase=backupdb --remote-host=5.35.82.243 --remote-user=postgres```. Проверил бэкапы и активность инстансов, исправил пару предупреждений, которые говорили о неполности конфига инстанса. 
Чтобы проверить созданные instance можно воспользоваться командой: ```pg_probackup show -B /home/backup_user/backup```
Чтобы посмотреть конфиг инстанса можно воспользоваться командой: ```pgprobackup show-config --instance db2```
## Неделя 4. День 3
### Monitoring
## Неделя 4. День 4
### Haproxy, KeepAlived, Samba, NFS
## Неделя 4. День 5
### ELK
## Неделя 5. День 1
### Puppet, Hiera, Ansible
## Неделя 5. День 2-5
### Проектная работа
## Неделя 6. День 1
### Финальная аттестация
