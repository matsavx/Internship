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
```
sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```
#### 4. memcached
```yum install memcached php-pecl-memcached```
```vi /etc/sysconfig/memcached```
```
PORT="11211"
USER="memcached"
MAXCONN="1024"
CACHESIZE="512"
OPTIONS="-l 127.0.0.1 -U 0"
```
```nano /etc/php.ini```
```
[Session]
session.save_handler = memcached
session.save_path = "127.0.0.1:11211"
```
Проверка:
```php -r "phpinfo();" | grep memcached```
```php -m | grep memcached```
#### 5. www -> без www
Добавил в конфиг nginx следующее:
```if ($host ~* ^www\.(.*)$) { return 301 $scheme://$server_name$request_uri; }```
#### 6. Drupal 10
```
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
composer create-project drupal/recommended-project:10.0.0 /var/www/my_drupal --stability dev --no-interaction
cd /var/www/my_drupal/
sudo chmod 666 composer.json
composer config --no-plugins allow-plugins.cweagans/composer-patches true
sudo /usr/local/bin/composer install
```
#### 7. Drupal 10 + postgresql-12
```yum install php-pgsql```
***
Подправил конфиг nginx добавлением обработки различным локейшенов, как написано на официальном сайте. Настроил постгрес под друпал:
```
su - postgres
psql
CREATE USER drupal WITH password 'drupal';
CREATE DATABASE drupaldb OWNER drupal;
GRANT ALL privileges ON DATABASE drupaldb TO drupal;
exit
psql -h localhost drupaldb drupal
ALTER DATABASE "drupaldb" SET bytea_output = 'escape';
yum install -y postgresql12-contrib
psql -h localhost drupaldb postgres
CREATE EXTENSION pg_trgm;
```
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
## Неделя 5. День 2-5. Проектная работа
Окончательно разобрался с vCenter, создал template (savchenko-template-almalinux-minimal), так как на образ almalinux-minimal есть только на кластере sandbox1, но на нем заканчивались ресурсы. Поэтому создал там template и через него создавал новые машинки на другом кластере. Менял адрес сервера через утилиту ```nmtui```. 
***
### ВМ
***
#### tadm-savchenko-web1
Данные: ```hostname=tadm-savchenko-web1```, ```almalinux 9.3```, ```ip=10.0.16.96```. 
(единственная кто отичается названием в vCenter, имя там tadm-savchenko, а hostname изменен на машине)
***
Приложения: ```Drupal 10.0.0```, ```nginx 1.25```, ```unit 1.31```, ```php 8.1.7```, ```unit-php```, ```php-pgsql```, ```memcached 1.6.9```, ```rsync 3.2.3```, ```node-exporter 1.7.0```, ```filebeat 7.9.3```

#### tadm-savchenko-web2
Данные:
```hostname=tadm-savchenko-web2```, ```almalinux 9.3```, ```ip=10.0.16.139```. 
***
Приложения ```Drupal 10.0.0```, ```nginx 1.25```, ```unit 1.31```, ```php 8.1.7```, ```unit-php```, ```php-pgsql```, ```memcached 1.6.9```, ```rsync 3.2.3```, ```node-exporter 1.7.0```, ```filebeat 7.9.3```

#### tadm-savchenko-pg1
Данные:
```hostname=tadm-savchenko-pg1```, ```almalinux 9.3```, ```ip=10.0.16.97```. 
***
Приложения: ```postgresql 12.17```, ```node-exporter 1.7.0```, ```filebeat 7.9.3```

#### tadm-savchenko-pg2
Данные:
```hostname=tadm-savchenko-pg2```, ```almalinux 9.3```, ```ip=10.0.16.98```. 
***
Приложения: ```postgresql 12.17```, ```node-exporter 1.7.0```, ```filebeat 7.9.3```.

#### tadm-savchenko-overseer
Данные:
```hostname=tadm-savchenko-overseer```, ```almalinux 9.3```, ```ip=10.0.16.87```. 
***
Приложения: ```prometheus 2.49.1```, ```grafana-server 9.2.10```, ```alertmanager 0.26.0```,```node-exporter 1.7.0```, ```filebeat 7.9.3```

#### tadm-savchenko-elk1
Данные:
```hostname=tadm-savchenko-elk1```, ```almalinux 9.3```, ```ip=10.0.16.84```. 
***
Приложения: ```elasticsearch-server 7.9.3```, ```logstash 7.9.3```, ```kibana 7.9.3```, ```openjdk 11.0.21```, ```node-exporter 1.7.0```, ```filebeat 7.9.3```

#### tadm-savchenko-ha1
Данные:
```hostname=tadm-savchenko-ha1```, ```almalinux 9.3```, ```ip=10.0.16.101```. 
***
Приложения: ```haproxy 2.8.3```, ```keepalived 2.2.8```,```node-exporter 1.7.0```, ```filebeat 7.9.3```

#### tadm-savchenko-ha21
Данные: ```hostname=tadm-savchenko-ha2```, ```almalinux 9.3```, ```ip=10.0.16.102```. 
***
Приложения: ```haproxy 2.8.3```, ```keepalived 2.2.8```,```node-exporter 1.7.0```, ```filebeat 7.9.3```

#### VIP
```ip = 10.0.16.68```
### web1 + web2
С описания web1 в "Промежуточном задании ничего практически ничего не изменилось, кроме того, что я удалил с неё postgresql и настроил rsync. Еще во время промежуточного задания я нарисовал в Drupal легкую преветственную страничку, но пароль от машины я потерял. Создав новую всё переустановил, но в этот раз никак не кастомизировал web страничку. Во-первых, не очень хотелось, а во-вторых, мне показалось, что для демонстрации работы проекта это никак не отобразится, потому что drupal хранит все фронтовые данные в БД. С rsync всё просто, установил и настроил конфиг на то, чтобы web2 мог синхронизировать папку "/var/www/my_drupal/", так как все изменения кода там (допустим когда я через композер подключаю новые расширения). ВМ web2 была полностью скопирована через vCenter с web1. Изменен только ip, hostname и конфиг rsync. Так же добавил сценарий для cron, на выполнение раз в час скрипта синхронизации, который я написал.
### pg1 + pg2
Полностью перенес постгрес на эти две машинки. pg1 - master, pg2 - slave. Настроил репликацию и бэкапирование по примеру, который я описал ранее.
### overseer
Prometheus, alertmanager и node_exporter устанавливал одинаково: Скачивал последнюю версию с официального сайта prometheus через wget, распаковывал архив и перемещал данные в /usr/local/bin, создавал пользователя под каждый сервис для запуска приложения, выдавал ему нужные права и в "/etc/systemd/system" создавал файлик сервиса для управления им. В конфиге prometheus указал в "targets" все сервера с портом экспортера 9100. node_exporter установил на все машинки, поигрался с добавлением whitelist для сервисов. В alertmanager особо не углублялся - создал простое правило на то, что nginx лежит больше минуты и в конфиге прометеуса настроил его отображение в веб-вьюшке.
### elk
Все пакеты брал с какого-то репозитория, который нашел в кф группы Циркон, так как elastic наложил санкции. Устанавливал скачанные пакеты через команду ```rpm -ivh kibana-*.rpm``` (например).
#### logastash конфиги
На каком порту слушается, т.е. как принимает: 
```vi /etc/logstash/conf.d/input.conf``` 
```
input { beats { port => 5044 } }
```
***
Самый простой фильтр для системных логов ```vi /etc/logstash/conf.d/filter.conf``` 
```
filter {
  if [type] == "syslog" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
      add_field => [ "received_at", "%{@timestamp}" ]
      add_field => [ "received_from", "%{host}" ]
    }
    date {
      match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
    }
  }
}
```
***
Ну и дефолтный конфиг на отправку логов в эластик:```vi /etc/logstash/conf.d/output.conf```
```
output {
  elasticsearch { hosts => ["localhost:9200"]
    hosts => "localhost:9200"
    manage_template => false
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}
```
#### filebeat
Настраивал этот конфиг на всех серверах одинаково: ```vi /etc/filebeat/filebeat.yml```. Тут активировал сбор логов файлбитом и указал пути до логов, откуда собирать. Закоментил опцию output.elasticsearch, так как она будет мешать, ну и собственно в output.logstash указал куда отправлять логи (где установлен logstash"). 
### ha1 + ha2
#### keepalived
```firewall-cmd --permanent --add-rich-rule='rule protocol value="vrrp" accept'```. Сам keepalived установил просто через yum и подправил конфиг в systemd, потому что дефолтный смотрит на не существующий файлик запуска, который находится в другом месте. Ну и отредактировал "keepalived.yml", который на обоих серверах отличается только опцией state, которая стоит "master" на ha1 и "backup" на ha2 Выглядит он так:
```
global_defs {
smtp_server 10.16.0.1
smtp_connect_timeout 30
router_id LVS_DEVEL
}
vrrp_instance VI_1 {
state MASTER
interface ens192 
virtual_router_id 51
priority 101
advert_int 1
authentication {
auth_type PASS
auth_pass 1111
}
virtual_ipaddress {
10.0.16.68
}
}
```
#### haproxy
```
yum -y install gcc perl pcre-devel openssl-devel zlib-devel readline-devel systemd-devel make (тут все в основном для сборки)
wget -O /tmp/haproxy.tgz https://www.haproxy.org/download/2.8/src/haproxy-2.8.3.tar.gz
tar -xzvf /tmp/haproxy.tgz -C /tmp && cd /tmp/haproxy-*
make USE_NS=1 USE_TFO=1 USE_OPENSSL=1 USE_ZLIB=1 USE_PCRE=1 USE_SYSTEMD=1 USE_LIBCRYPT=1 USE_THREAD=1 TARGET=linux-glibc
make TARGET=linux-glibc install-bin install-man
cp /usr/local/sbin/haproxy /usr/sbin/haproxy
mkdir -p /var/lib/haproxy
mkdir -p /etc/haproxy
cat <<'EOT' | sudo tee /etc/systemd/system/haproxy.service (тут длинный дефолтный конфиг для сервиса)
cat <<EOT | sudo tee /etc/sysconfig/haproxy CLI_OPTIONS="-Ws" CONFIG_FILE=/etc/haproxy/haproxy.cfg PID_FILE=/var/run/haproxy.pid EOT
systemctl daemon-reload
haproxy -v
vim /etc/haproxy/haproxy.cfg
usr/local/sbin/haproxy -c -V -f /etc/haproxy/haproxy.cfg
systemctl enable haproxy.service
systemctl start haproxy.service
```
***
Ну и нашел дефолтный конфиг, который сначала пытался поменять под 443 и SSL, так как web-сервера на которых смотрели хапрокси слушались на 443, но у меня не получилось. Возможно проблема в самоподписанных сертификатов, что на web, что на haproxy, ну либо я не так что-то делаю. Вернул конфиг в рабочее состояние, слушает сервера на 80м порту. Чтобы все работало - переписал конфиг nginx на web-машинках на работу без ssl.
## Неделя 6. День 1
### Финальная аттестация
