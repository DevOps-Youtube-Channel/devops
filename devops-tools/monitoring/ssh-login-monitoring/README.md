## Уведомления когда пользователь заходит в сервер по SSH

Работает в популярных Linux системах (Debian, Ubuntu, Arch Linux итд..)

![Example](msg.png)

### Зависимости
- curl
- git

### Установка
1) Сначала создайте папку  ```mkdir -p /opt/ssh-login-alert-telegram && cd /opt/ssh-login-alert-telegram```
   
2) Клонируем либо скачаем архив  ```git clone https://github.com/DevOps-Youtube-Channel/devops && mv devops/devops-tools/monitoring/ssh-login-monitoring/* /opt/ssh-login-alert-telegram```

3) Редактируем два переменных в файле credentials.config:
```nano credentials.config```

4) Выполянем скрипт:
```bash deploy.sh```

5) Все теперь можем проверить подключив к серверу по ssh.


### Установка по Ansible (источник)

Если у вас много серверов: https://github.com/MyTheValentinus/Deploy-Telegram-SSH-Alerting-with-Ansible (fork of initial @stylernico work)
