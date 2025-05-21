```
<VirtualHost *:80>
    ServerName 192.168.159.135

    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/access.error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
