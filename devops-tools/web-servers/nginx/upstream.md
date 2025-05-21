```
upstream backend_servers {
    server 192.168.10.11:3000;
    server 192.168.10.12:3000;
}

server {
    listen 80;
    server_name example.uz www.example.uz;

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name example.uz www.example.uz;

    ssl_certificate     /etc/letsencrypt/live/example.uz/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.uz/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        application/json
        application/javascript
        text/xml
        application/xml
        image/svg+xml
        font/ttf
        font/otf;

    location / {
        proxy_pass http://backend_servers;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
