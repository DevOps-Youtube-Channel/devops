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
   ```cd /opt sudo wget https://downloads.apache.org/zookeeper/zookeeper-3.6.2/apache-zookeeper-3.6.2-bin.tar.gz```
