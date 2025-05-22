Установим Harbor

Для этого заходим на официальный сайт: ```https://github.com/goharbor/harbor/releases/tag/v2.12.1```

1) Cкачиваем на сервер:  ```wget https://github.com/goharbor/harbor/releases/download/v2.12.1/harbor-online-installer-v2.12.1.tgz```
2) Разархивируем архив: ```tar xzvf harbor-online-installer-v2.12.1.tgz```
3) Создадим папку для работы: ```mkdir /opt/docker```
4) Перенесем папку harbor в opt директорию: ```mv harbor /opt/docker/ && cd /opt/docker/harbor```
5) Cоздадим файл harbor.yml: ```mv harbor.yml.tmpl harbor.yml```
6) Редактируем файл harbor.yml: ```nano harbor.yml```
   ```
     # Configuration file of Harbor
     # The IP address or hostname to access admin UI and registry service.
     # DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
   hostname: harbor.beeline.uz

     # http related config
   http:
     # port for http, default is 80. If https enabled, this port will redirect to https port
     port: 80

     # https related config
   https:
     # https port for harbor, default is 443
     port: 443
     # The path of cert and key files for nginx
   certificate: /etc/docker/certs.d/harbor.farrukh.uz/harbor.farrukh.uz.cert
   private_key: /etc/docker/certs.d/harbor.farrukh.uz/harbor.farrukh.uz.key
   ```
7) Создадим сервис для harbor: ```nano /etc/systemd/system/harbor.service```
   ```
   [Unit]
   Description=Harbor Container Registry
   Requires=docker.service
   After=docker.service

   [Service]
   Type=oneshot
   RemainAfterExit=true
   WorkingDirectory=/opt/docker/harbor
   ExecStart=/opt/docker/harbor/start.sh
   ExecStop=/opt/docker/harbor/stop.sh
   ExecReload=/opt/docker/harbor/restart.sh
   TimeoutStartSec=0

   [Install]
   WantedBy=multi-user.target
   ```
8) 
