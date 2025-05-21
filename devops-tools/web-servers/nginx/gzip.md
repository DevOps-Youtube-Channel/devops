### Настройки Gzip в основном Nginx файле

```
http {
    gzip on;
    gzip_disable "msie6";  # не включать для IE6

    gzip_vary on;                     # для кэширования прокси
    gzip_proxied any;                # сжимать даже если прокси
    gzip_comp_level 6;               # уровень сжатия (1-9)
    gzip_buffers 16 8k;              # буферы
    gzip_http_version 1.1;
    gzip_types                       # какой тип файла хотите сжать
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/rss+xml
        image/svg+xml
        font/ttf
        font/otf;
}
```


### Локальной настройки в server блоке (например, в example.uz)

```
server {
    listen 80;
    server_name example.uz;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

    location / {
        proxy_pass http://127.0.0.1:3000;
        ...
    }
}
```


























