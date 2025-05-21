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
