# Gitlab-Server

1) Cоздадим папку для сертификатов:   ```mkdir /root/ssl && cd /root/ssl/```

2) Установим запись в файле ```nano /etc/hosts``` у gitlab сервера
   ```
   gitlab.open.home 192.168.95.18
   ```
   
3) Cгенерируем сертификат:
   ```
   openssl req -x509 -newkey rsa:4096 -keyout gitlab.open.home.key -out gitlab.open.home.cert -nodes -subj '/CN=gitlab.open.home' -days 365
   ```
   
4) Редактируем файл gitlab.rb:  ```nano /etc/gitlab/gitlab.rb```
   ```
   external_url 'https://gitlab.open.home'
   ```

5) Скопируем сертификаты
   ```
   sudo mkdir -p /etc/gitlab/ssl
   sudo chmod 755 /etc/gitlab/ssl
   sudo rm -rf /etc/gitlab/ssl/*
   sudo cp /root/ssl/gitlab.open.home* /etc/gitlab/ssl/
   sudo chmod 600 /etc/gitlab/ssl/gitlab.open.home*
   ```

6) Реконфигирируем Gitlab
   ```
   gitlab-ctl reconfigure
   ```

# Gitlab-Runner

1) Игнорируем сертификата
   ```
   SERVER=gitlab.rom.home
   PORT=443
   CERTIFICATE=/etc/gitlab-runner/certs/${SERVER}.crt
   mkdir -p $(dirname "$CERTIFICATE")
   openssl s_client -connect ${SERVER}:${PORT} -showcerts </dev/null 2>/dev/null | sed -e '/-----BEGIN/,/-----END/!d' | sudo tee "$CERTIFICATE" >/dev/null
   gitlab-runner register --tls-ca-file="$CERTIFICATE"
   ```












