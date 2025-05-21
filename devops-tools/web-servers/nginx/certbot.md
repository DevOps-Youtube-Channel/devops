Получение SSL-сертификата через Let's Encrypt

1) Установка:
   ```
   sudo apt update
   sudo apt install certbot python3-certbot-nginx
   ```

2) Запустить автонастройку:
   ```
   sudo certbot --nginx -d example.uz -d www.example.uz
   ```

3) Автопродление:
   ```
   sudo certbot renew --dry-run
   ```

