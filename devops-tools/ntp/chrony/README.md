## Chrony NTP Server
![Example](images/chrony-ntp.png)

### Установка в Ubuntu
1) Сначала обновим список пакетов  ```apt-get update```
2) Установим сам Chrony ```apt-get install chrony -y```
3) Установим Timezone ```timedatectl set-timezone Asia/Tashkent```
4) Перезапустим сервис и посмотрим статус  ```systemctl restart chronyd.service && systemctl status chronyd.service```

### Пример конфиг файла сервера
![Example](images/chrony-server.png)

### Команды сервера
1) Включение использование systemd-timesyncd для синхронизации времени ```timedatectl set-ntp true```
2) Установка Timezone ```timedatectl set-timezone Asia/Tashkent```
3) Проверка текущего источника времени  ```chronyc sources```
4) Проверка статуса источников NTP ```chronyc activity```
5) Список клиентов ```chronyc clients```

### Пример конфиг файла клиента
![Example](images/chrony-client.png)

### Команды клиента
1) Включение использование systemd-timesyncd для синхронизации времени ```timedatectl set-ntp true```
2) Проверка текущего источника времени  ```chronyc sources```

### Официальная документация
https://chrony-project.org/
