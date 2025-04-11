### Zookeper

1) Установка Java на все узлы: ```ha-zoo1, ha-zoo2, ha-zoo3```
   ```
   sudo apt update 
   apt install -y openjdk-11-jdk
   ```

2) Установим названия для вир машин: ```nano /etc/hosts```
   ```
   10.20.20.51 ha-zoo1
   10.20.20.52 ha-zoo2
   10.20.20.53 ha-zoo3
   ```

3) Cкачиваем Zookeper и установим на все узлы:
   ```
   cd /opt sudo wget https://downloads.apache.org/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz
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

6) Настроим id на ha-zoo1: ```echo 1 > /data/zookeeper/myid```
7) Настроим id на ha-zoo2: ```echo 2 > /data/zookeeper/myid```
8) Настроим id на ha-zoo3: ```echo 3 > /data/zookeeper/myid```

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
   10.20.20.41 ha-kafka1
   10.20.20.42 ha-kafka2
   10.20.20.43 ha-kafka3
   10.20.20.51 ha-zoo1
   10.20.20.52 ha-zoo2
   10.20.20.53 ha-zoo3
   ```

3)

























   
