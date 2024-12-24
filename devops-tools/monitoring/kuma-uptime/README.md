## Uptime Kuma — простой в использовании автономный инструмент мониторинга.

![Example](kuma-uptime.png)


### Установка
1) Установите Docker: ```https://github.com/DevOps-Youtube-Channel/devops/tree/main/devops-tools/docker/install/ubuntu```
2) Создайте файл ```docker-compose.yaml```

  ```services:
  uptime-kuma:
    image: louislam/uptime-kuma:1
    volumes:
      - ./data:/app/data
    ports:
      # <Host Port>:<Container Port>
      - 3001:3001
    restart: always```

3) Запускайте compose файл: ```docker-compose up -d```

4) Запросите страницу:  ```http://xxx.xxx.xxx.xxx:3001```



### Источник:  ```https://github.com/louislam/uptime-kuma?tab=readme-ov-file```
