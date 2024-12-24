## Уведомления когда пользователь заходит в сервер по SSH

Работает в популярных Linux системах (Debian, Ubuntu, Arch Linux итд..)

![Example](msg.png)

### Зависимости
- curl
- git

### Установка
1) Сначала создайте папку        ```mkdir -p /opt/ssh-login-alert-telegram && cd /opt/ssh-login-alert-telegram```
   
2) Клонируем либо скачаем архив в эту папку   ```git clone https://github.com/DevOps-Youtube-Channel/devops && cd devops/devops-tools/monitoring/ssh-login-monitoring```

3) Edit two configuration variables by editing credentials.config:
```vim credentials.config```

4) Add this script when user connect with the deploy script:
```bash deploy.sh```

5) Confirm that the script is working by logging you to ssh again.


### Install with Ansible

If you have many servers go check: https://github.com/MyTheValentinus/Deploy-Telegram-SSH-Alerting-with-Ansible (fork of initial @stylernico work)
