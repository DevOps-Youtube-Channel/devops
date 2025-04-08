# Gitlab-Server

1) Cоздадим папку для сертификатов:   ```mkdir /root/ssl && cd /root/ssl/```

2) Установим запись в файле ```nano /etc/hosts``` у gitlab сервера
   ```
   gitlab.open.local 192.168.95.18
   ```
   
3) Cгенерируем сертификат:
   ```
   openssl req -x509 -newkey rsa:4096 -keyout gitlab.open.local.key -out gitlab.open.local.crt -nodes -subj '/CN=gitlab.open.local' -days 365
   ```
   
4) Редактируем файл gitlab.rb:  ```nano /etc/gitlab/gitlab.rb```
   ```
   external_url 'https://gitlab.open.local'
   ```

5) Скопируем сертификаты
   ```
   sudo mkdir -p /etc/gitlab/ssl
   sudo chmod 755 /etc/gitlab/ssl
   sudo rm -rf /etc/gitlab/ssl/*
   sudo cp /root/ssl/gitlab.open.local* /etc/gitlab/ssl/
   sudo chmod 600 /etc/gitlab/ssl/gitlab.open.local*
   ```

6) Реконфигирируем Gitlab
   ```
   gitlab-ctl reconfigure
   ```

# Gitlab-Runner

1) Игнорируем сертификата
   ```
   SERVER=gitlab.open.local
   PORT=443
   CERTIFICATE=/etc/gitlab-runner/certs/${SERVER}.crt
   mkdir -p $(dirname "$CERTIFICATE")
   openssl s_client -connect ${SERVER}:${PORT} -showcerts </dev/null 2>/dev/null | sed -e '/-----BEGIN/,/-----END/!d' | sudo tee "$CERTIFICATE" >/dev/null
   gitlab-runner register --tls-ca-file="$CERTIFICATE"
   ```












