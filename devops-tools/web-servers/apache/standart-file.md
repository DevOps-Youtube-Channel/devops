```
<VirtualHost *:80>
    ServerName example.uz

    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/access.error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>


<VirtualHost *:443>
    ServerName example.uz
    ServerAlias www.example.uz

    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    # SSL-настройки
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/example.uz/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/example.uz/privkey.pem

    ErrorLog ${APACHE_LOG_DIR}/example.uz.ssl.error.log
    CustomLog ${APACHE_LOG_DIR}/example.uz.ssl.access.log combined
</VirtualHost>
```
