1. Cгенерируем ключ для домена:   ```mkdir ssl && cd ssl/```

2. Cоздадим файл для генерации сертификата: ```cat sslcert.conf```
   
```
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = IN
ST = MH
L = Mumbai
O = stack
OU = devops
CN = gitserver.stack.com
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = gitserver.stack.com
DNS.2 = gitrunner.stack.com
```

4. Cгенерируем сертификат: ```openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout gitserver.stack.com.key -out gitserver.stack.com.crt -config sslcert.conf -extensions 'v3_req' Generating a RSA private key```

5. Редактируем файл gitlab.rb:  ```nano /etc/gitlab/gitlab.rb```
   ```external_url 'https://gitserver.stack.com'```

6. Скопируем сертификаты
```sudo mkdir -p /etc/gitlab/ssl
   sudo chmod 755 /etc/gitlab/ssl
   sudo cp gitserver.stack.com.key gitserver.stack.com.crt /etc/gitlab/ssl/
   sudo chmod 600 /etc/gitlab/ssl/gitserver.stack.*
```

8. Реконфигирируем Gitlab
```gitlab-ctl reconfigure```

9. Проверим валидность сертификата
openssl s_client -connect gitserver.stack.com:443












