### Zookeper

1) Установка Java на все узлы: ```ha-zoo1, ha-zoo2, ha-zoo3```
   ```
   sudo apt update 
   apt install -y openjdk-11-jdk
   ```

2) Установим названия для вир машин: ```nano /etc/hosts```
   ```
   192.168.95.24 ha-zoo1
   192.168.95.25 ha-zoo2
   192.168.95.26 ha-zoo3
   ```

3) Cкачиваем Zookeper и установим на все узлы:
   ```
   cd /opt sudo && wget https://downloads.apache.org/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz
   ```

4) Разархивируем архив на всех узлах:
   ```
   sudo tar -xvf apache-zookeeper-3.6.2-bin.tar.gz
   sudo mv apache-zookeeper-3.6.2 zookeeper
   cd zookeeper
   ```

5) Настроим мулти-zookeper на всех узлах: ```sudo vi conf/zoo.cfg```
   ```
   tickTime=2000
   dataDir=/data/zookeeper
   clientPort=2181
   initLimit=10
   syncLimit=5
   server.1=ha-zoo1:2888:3888
   server.2=ha-zoo2:2888:3888
   server.3=ha-zoo3:2888:3888
   ```

6) Настроим id на ha-zoo1:
   ```
   echo 1 > /data/zookeeper/myid
   ```
7) Настроим id на ha-zoo2:
   ```
   echo 2 > /data/zookeeper/myid
   ```
8) Настроим id на ha-zoo3:
    ```
    echo 3 > /data/zookeeper/myid
    ```

9) Запустим zookeper на всех узлах:
    ```
   java -cp lib/zookeeper-3.6.2.jar:lib/*:conf org.apache.zookeeper.server.quorum.QuorumPeerMain conf/zoo.cfg
    ```

10) Проверим zookeper на ha-zoo3:
    ```
    cd /opt/zookeeper
    bin/zkCli.sh -server ha-zoo1:2181
    [zk: ha-zoo3:2181(CONNECTED) 0] ls /
    [zookeeper]
    [zk: ha-zoo3:2181(CLOSED) 3] quit
    ```

### Kafka

1) Установим на все узлы Java:
   ```
   apt update
   apt install -y openjdk-11-jdk
   ```

2) На каждом узле установим хосты: ```vi /etc/hosts```
   ```
   192.168.95.27 ha-kafka1
   192.168.95.28 ha-kafka2
   192.168.95.29 ha-kafka3
   192.168.95.24 ha-zoo1
   192.168.95.25 ha-zoo2
   192.168.95.26 ha-zoo3
   ```

3) Создадим папку /opt и скачиваем кафку:
   ```
   mkdir /opt/kafka && curl https://downloads.apache.org/kafka/2.6.0/kafka_2.13-2.6.0.tgz -o /opt/kafka/kafka.tgz
   ```

4) Переходим на /opt папку и разархивируем архив
   ```cd /opt/kafka && tar xvfz kafka.tgz --strip 1```

5) Создадим кафку хранилищие у всех нодах:
   ```sudo mkdir -p /data/kafka/log && chown -R ubuntu:ubuntu /data/kafka/```

6) На всех узлах отредактируете это файл: ```nano bin/config/server.properties```
   ```
   log.dirs=/data/kafka/log
   num.partitions=3
   zookeeper.connect=ha-zoo1:2181,ha-zoo2:2181,ha-zoo3:2181
   ```

7) Создадим уникальные broker id на ha-kafka1: ```nano bin/config/server.properties```
   ```
   broker.id=0
   ```

8) Создадим уникальные broker id на ha-kafka2: ```nano bin/config/server.properties```
   ```
   broker.id=1
   ```

9) Создадим уникальные broker id на ha-kafka3: ```nano bin/config/server.properties```
   ```
   broker.id=2
   ```

10) Создадим кафку как сервис: nano /etc/systemd/system/kafka.service
    ```
    [Unit]
    Description=Kafka
    Before=
    After=network.target
    [Service]
    User=ubuntu
    CHDIR= {{ data_dir }}
    ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
    Restart=on-abort
    [Install]
    WantedBy=multi-user.target
    ```

11) Перезапустим службу и проверим статус Kafka:
    ```
    sudo systemctl daemon-reload
    sudo systemctl start kafka.service
    sudo systemctl enable kafka.service
    sudo systemctl status kafka.service
    ```

12) Создадим тестовый топик у сервера ha-kafka1:
    ```
    bin/kafka-topics.sh --create --bootstrap-server ha-kafka1:9092 ha-kafka2:9092 ha-kafka3:9092 --topic test-multibroker
    ```

13) Посмотрим список топиков у сервера ha-kafka1:
    ```
    bin/kafka-topics.sh --list --bootstrap-server ha-kafka1:9092 ha-kafka2:9092 ha-kafka3:9092 test-multibroker
    ls /data/kafka/log/
    ```























   
