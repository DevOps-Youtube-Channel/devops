Инсталляция HashiCorp Vault в HA режиме с integrated storage

Необходимые ресурсы:
vault-a.open.lab 192.168.95.24 Ubuntu 22.04 server
vault-b.open.lab 192.168.95.25 Ubuntu 22.04 server
vault-c.open.lab 192.168.95.26 Ubuntu 22.04 server

haproxy1 192.168.95.27 Ubuntu 22.04 server
haproxy2 192.168.95.28 Ubuntu 22.04 server

VIP_IP_ADDRESS 192.168.95.29


### VAULT

1) На каждой ноде добавим следующие записи в ```nano /etc/hosts``` (vault-a.open.lab, vault-b.open.lab, vault-c.open.lab): 
   ```
   vault-a.open.lab 192.168.95.24
   vault-b.open.lab 192.168.95.25
   vault-c.open.lab 192.168.95.26
   ```

2) Установим hostname на каждой ноде (vault-a.open.lab, vault-b.open.lab, vault-c.open.lab):
   ```
   hostnamectl set-hostname vault-a.open.lab
   hostnamectl set-hostname vault-b.open.lab
   hostnamectl set-hostname vault-c.open.lab
   ```
3) Установим на каждой ноде vault (vault-a.open.lab, vault-b.open.lab, vault-c.open.lab):
   ```
   wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install vault
   vault -v
   ```

4) Далее необходимо обзавестись сертификатами. Если таковые отсутствуют – выпустить свои, самоподписанные. Все операции я выполняю с первой ноды vault-a.open.lab.
   Сперва выпустим свой CA сертификат, а затем с его помощью подпишем сертификаты для всех узлов кластера:
   ```
   cd /opt/vault/tls/
   rm -rf *
   openssl genrsa 2048 > vault-ca-key.pem
   openssl req -new -x509 -nodes -days 3650 -key vault-ca-key.pem -out vault-ca-cert.pem
   ```

5) Теперь подготовим конфигурационные файлы, содержащие Subject Alternate Name (SAN) для каждого из узлов. Важно, чтобы в SAN был корректней хостнейм и IP каждого узла.
   Все операции я выполняю с первой ноды vault-a.open.lab:
   ```
   echo "[v3_ca]
   subjectAltName = @alt_names
   [alt_names]
   DNS.1 = vault-a.vmik.lab
   IP.1 = 192.168.100.9
   IP.2 = 127.0.0.1
   " > ./cert-a.cfg
   ```
   ```
   echo "[v3_ca]
   subjectAltName = @alt_names
   [alt_names]
   DNS.1 = vault-b.vmik.lab
   IP.1 = 192.168.100.10
   IP.2 = 127.0.0.1
   " > ./cert-b.cfg
   ```



































   
