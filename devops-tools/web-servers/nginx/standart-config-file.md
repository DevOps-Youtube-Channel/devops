### Рассмотрим классический конфиг nginx

```
server {
    listen 192.168.10.10:80;
    server_name example.uz www.example.uz;

    location / {
        return 301 https://$host$request_uri;
    }
}


server {
    listen 192.168.10.10:443 ssl;
    server_name example.uz www.example.uz;


    ssl_certificate     /home/iadmin/example_ssl_new_new/STAR_example_uz.crt;
    ssl_certificate_key /home/iadmin/example_ssl_new_new/example_private.key.txt;

    access_log /var/log/nginx/example.uz_access.log;
    error_log /var/log/nginx/example.uz_error.log;



    location / {
        proxy_pass http://192.168.10.11:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Описание

```
server - Начало серверного блока. Один server — один виртуальный хост
listen 192.168.10.10:80; - nginx слушает IP 192.168.10.10 на порту 80 (HTTP)
server_name example.uz www.example.uz; - Указывает, для каких доменов действует этот блок
location / { return 301 https://$host$request_uri; } - все запросы перенаправляются с HTTP на HTTPS с кодом 301 (постоянный редирект)
$host - домен из запроса
$request_uri — путь и параметры запроса
listen 192.168.10.10:443 ssl; - слушает HTTPS на IP 192.168.10.10, порт 443, с включённым SSL
ssl_certificate -	путь к публичному сертификату (например, *.crt)
ssl_certificate_key	- путь к приватному ключу сертификата
server_name	- домен(ы), для которых предназначен этот блок
proxy_pass http://192.168.10.11:3000;	- nginx перенаправляет запросы на внутренний сервер (бэкенд) по IP 192.168.10.11 и порту 3000
proxy_http_version 1.1;	- указывает использовать HTTP/1.1 — нужен для работы WebSocket и keep-alive
proxy_set_header Upgrade $http_upgrade;	- поддержка протоколов, использующих заголовок Upgrade (например, WebSocket)
proxy_set_header Connection 'upgrade';	- обязателен вместе с Upgrade для WebSocket
proxy_set_header Host $host;	- передаёт оригинальный домен клиента на бэкенд
proxy_cache_bypass $http_upgrade;	- отключает кеширование при использовании WebSocket
```
































