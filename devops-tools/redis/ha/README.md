Необходимые вир машины
3 сервера для Redis-Server/Sentinal
2 сервера для Haproxy
1 клиент сервер

REDIS CLUSTER 
1) Установка и начальная настройка Redis:
   apt install net-tools -y
   sudo apt install redis-server -y
   systemctl status redis.service
   sudo nano /etc/redis/redis.conf

3)  Открытие порта Redis в UFW:
   sudo ufw allow 6379

4) Создание переменных окружения:
   export REDIS_MASTER_PRIVATE_IP=192.168.95.23
   export REDIS_PORT=6379
   export REDIS_PASS=redis-master

5) Настройка мастера Redis. Команды выполнять на мастер ноде:
   sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.backup && \
   sudo sed -i -E "s/(bind 127.0.0.1 ::1)//g" /etc/redis/redis.conf && \
   echo "requirepass $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   echo "masterauth $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   sudo service redis-server restart

6) Настройка реплики Redis. Команды выполнять на воркер нодах:
   sudo sed -i -E "s/(bind 127.0.0.1 ::1)//g" /etc/redis/redis.conf && \
   echo "requirepass $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   echo "masterauth $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   echo "replicaof $REDIS_MASTER_PRIVATE_IP $REDIS_PORT" | sudo tee -a /etc/redis/redis.conf && \
   sudo service redis-server restart

7) Проверка кластера
   redis-cli -a redis-master -h 192.168.95.23 -p 6379 info replication
   redis-cli -a redis-master -p 6379 info replication
   redis-cli -a redis-master -p 26379 info sentinel

8) Проверка на запись на мастере
   redis-cli -a redis-master -p 6379
   set test 1

 9) Переключимся на слейв и проверим   
   redis-cli -a redis-master -p 6379
   get test

10) 
   
