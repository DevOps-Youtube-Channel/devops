Необходимые вир машины
Redis-Server/Sentinal:
```
192.168.95.23, 192.168.95.24, 192.168.95.25
```
Haproxy: 
```
192.168.95.26, 192.168.95.27
```
Client: 
```
192.168.95.28
```

REDIS CLUSTER 
1) Установка и начальная настройка Redis. Команды выполняются на всех машинах:
   ```
   apt install net-tools -y
   sudo apt install redis-server -y
   systemctl status redis.service
   sudo nano /etc/redis/redis.conf
   ```

2)  Открытие порта Redis в UFW. Команды выполняются на всех машинах:
    ```
    sudo ufw allow 6379
    ```

3) Создание переменных окружения. Команды выполняются на всех машинах:
   ```
   export REDIS_MASTER_PRIVATE_IP=192.168.95.23
   export REDIS_PORT=6379
   export REDIS_PASS=redis-master
   ```

4) Настройка мастера Redis. Команды выполнять на мастер ноде:
   ```
   sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.backup && \
   sudo sed -i -E "s/(bind 127.0.0.1 ::1)//g" /etc/redis/redis.conf && \
   echo "requirepass $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   echo "masterauth $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   sudo service redis-server restart
   ```

5) Настройка реплики Redis. Команды выполнять на воркер нодах:
   ```
   sudo sed -i -E "s/(bind 127.0.0.1 ::1)//g" /etc/redis/redis.conf && \
   echo "requirepass $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   echo "masterauth $REDIS_PASS" | sudo tee -a /etc/redis/redis.conf && \
   echo "replicaof $REDIS_MASTER_PRIVATE_IP $REDIS_PORT" | sudo tee -a /etc/redis/redis.conf && \
   sudo service redis-server restart
   ```

6) Проверка кластера
    ```
    redis-cli -a redis-master -h 192.168.95.23 -p 6379 info replication
    redis-cli -a redis-master -p 6379 info replication
    redis-cli -a redis-master -p 26379 info sentinel
    ```

7) Проверка на запись на мастере
    ```
    redis-cli -a redis-master -p 6379
    set test 1
    ```

 8) Переключимся на слейв и проверим   
     ```
     redis-cli -a redis-master -p 6379
     get test
     ```

SENTINAL

1) Установка Redis Sentinel. Команды выполняются на всех машинах:
   ```
   sudo apt install redis-sentinel -y
   systemctl status sentinel.service
   ```

2) Открытие порта Redis в UFW. Команды выполняются на всех машинах:
   ```
   sudo ufw allow 6379 && \
   sudo ufw allow 26379
   ```
   
3) Создание переменных окружения. Команды выполняются на всех машинах:
   ```
   sudo cp /etc/redis/sentinel.conf /etc/redis/sentinel.conf.backup && \
   export REDIS_MASTER_PRIVATE_IP=192.168.95.23 && \
   export REDIS_PORT=6379 && \
   export REDIS_SENTINEL_NAME=mymaster && \
   export REDIS_PASS=redis-master && \
   export REDIS_SENTINEL_QUORUM=2
   ```

4) Очистка и модификация дефолтных строк в конфиге. Команды выполняются на всех машинах:
   ```
   sudo sed -i -E "s/(bind 127.0.0.1 ::1)//g" /etc/redis/sentinel.conf && \
   sudo sed -i -E "s/(sentinel config-epoch mymaster 0)//g" /etc/redis/sentinel.conf && \
   sudo sed -i -E "s/(sentinel leader-epoch mymaster 0)//g" /etc/redis/sentinel.conf && \
   sudo sed -i -E "s/(sentinel monitor mymaster 127.0.0.1 6379 2)//g" /etc/redis/sentinel.conf
   ```

5) Добавление новой конфигурации. Команды выполняются на всех машинах:
   ``` 
   echo "protected-mode yes" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "requirepass $REDIS_PASS" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "sentinel monitor $REDIS_SENTINEL_NAME $REDIS_MASTER_PRIVATE_IP $REDIS_PORT $REDIS_SENTINEL_QUORUM" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "sentinel auth-pass $REDIS_SENTINEL_NAME $REDIS_PASS" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "sentinel down-after-milliseconds $REDIS_SENTINEL_NAME 3000" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "sentinel failover-timeout $REDIS_SENTINEL_NAME 6000" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "sentinel parallel-syncs $REDIS_SENTINEL_NAME 1" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "sentinel config-epoch $REDIS_SENTINEL_NAME 0" | sudo tee -a /etc/redis/sentinel.conf && \
   echo "sentinel leader-epoch $REDIS_SENTINEL_NAME 0" | sudo tee -a /etc/redis/sentinel.conf
   ```

6) Перезапустим службу sentinal
   ``` 
   systemctl restart sentinel.service
   systemctl status sentinel.service
   redis-cli -a redis-master -p 26379 info sentinel
   ```

HAPROXY

1) Установка HAProxy и настройка фаервола:
   ```
   sudo apt install haproxy -y
   sudo ufw allow 6379
   ```

2) Создание бэкапа конфига HAProxy:
   ```
   sudo cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.backup
   ```

4) Экспорт переменных окружения:
   ```
   export REDIS_IP1="192.168.95.23"
   export REDIS_IP2="192.168.95.24"
   export REDIS_IP3="192.168.95.25"
   export REDIS_PORT="6379"
   export REDIS_PASS="redis-master"
   ```

5) Генерация и применение конфига HAProxy:
   ```
   echo "frontend ft_redis
           bind *:6379 name redis
           mode tcp
           default_backend bk_redis

   backend bk_redis
           mode tcp
           option tcp-check
           tcp-check connect

           tcp-check send AUTH \$REDIS_PASS\\r\\n
           tcp-check expect string +OK
           tcp-check send PING\\r\\n
           tcp-check expect string +PONG
           tcp-check send info\\ replication\\r\\n

           tcp-check expect string role:master
           tcp-check send QUIT\\r\\n
           tcp-check expect string +OK
           server Redis1 \$REDIS_IP1:\$REDIS_PORT check inter 3s
           server Redis2 \$REDIS_IP2:\$REDIS_PORT check inter 3s
           server Redis3 \$REDIS_IP3:\$REDIS_PORT check inter 3s
   " | sudo tee /etc/haproxy/haproxy.cfg
   ```
































