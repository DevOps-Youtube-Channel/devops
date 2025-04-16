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
   DNS.1 = vault-a.open.lab
   IP.1 = 192.168.95.24
   IP.2 = 127.0.0.1
   " > ./cert-a.cfg
   ```
   ```
   echo "[v3_ca]
   subjectAltName = @alt_names
   [alt_names]
   DNS.1 = vault-b.open.lab
   IP.1 = 192.168.95.25
   IP.2 = 127.0.0.1
   " > ./cert-b.cfg
   ```
   ```
   echo "[v3_ca]
   subjectAltName = @alt_names
   [alt_names]
   DNS.1 = vault-c.open.lab
   IP.1 = 192.168.95.26
   IP.2 = 127.0.0.1
   " > ./cert-c.cfg
   ```

6) Теперь для каждого из узлов сформируем CSR файл. Все операции я выполняю с первой ноды vault-a.open.lab:
   ```
   openssl req -newkey rsa:2048 -nodes -keyout vault-a-key.pem -out vault-a-csr.pem -subj "/CN=vault-a.open.lab"
   openssl req -newkey rsa:2048 -nodes -keyout vault-b-key.pem -out vault-b-csr.pem -subj "/CN=vault-b.open.lab"
   openssl req -newkey rsa:2048 -nodes -keyout vault-c-key.pem -out vault-c-csr.pem -subj "/CN=vault-c.open.lab"
   ```

7) И выпустим сертификаты на основании запросов. Все операции я выполняю с первой ноды vault-a.open.lab:
   ```
   openssl x509 -req -set_serial 01 -days 3650 -in vault-a-csr.pem -out vault-a-cert.pem -CA vault-ca-cert.pem -CAkey vault-ca-key.pem -extensions v3_ca -extfile ./cert-a.cfg
   openssl x509 -req -set_serial 01 -days 3650 -in vault-b-csr.pem -out vault-b-cert.pem -CA vault-ca-cert.pem -CAkey vault-ca-key.pem -extensions v3_ca -extfile ./cert-b.cfg
   openssl x509 -req -set_serial 01 -days 3650 -in vault-c-csr.pem -out vault-c-cert.pem -CA vault-ca-cert.pem -CAkey vault-ca-key.pem -extensions v3_ca -extfile ./cert-c.cfg
   ```

8) Скопируем сертификаты и ключи на узлы vault-b.open.lab и vault-c.open.lab:
   ```
   scp ./vault-b-key.pem ./vault-b-cert.pem ./vault-ca-cert.pem vault-b.open.lab:/opt/vault/tls
   scp ./vault-c-key.pem ./vault-c-cert.pem ./vault-ca-cert.pem vault-c.open.lab:/opt/vault/tls
   ```

9) На каждом из узлов установим соответствующие права для доступа к файлам сертификатов и ключам (vault-a.open.lab):
   ```
   chown root:root /opt/vault/tls/vault-a-cert.pem /opt/vault/tls/vault-ca-cert.pem
   chown root:vault /opt/vault/tls/vault-a-key.pem
   chmod 0644 /opt/vault/tls/vault-a-cert.pem /opt/vault/tls/vault-ca-cert.pem
   chmod 0640 /opt/vault/tls/vault-a-key.pem
   ```

10) На каждом из узлов установим соответствующие права для доступа к файлам сертификатов и ключам (vault-b.open.lab):
    ```
    chown root:root /opt/vault/tls/vault-b-cert.pem /opt/vault/tls/vault-ca-cert.pem
    chown root:vault /opt/vault/tls/vault-b-key.pem
    chmod 0644 /opt/vault/tls/vault-b-cert.pem /opt/vault/tls/vault-ca-cert.pem
    chmod 0640 /opt/vault/tls/vault-b-key.pem
    ```

11) На каждом из узлов установим соответствующие права для доступа к файлам сертификатов и ключам (vault-c.open.lab):
    ```
    chown root:root /opt/vault/tls/vault-c-cert.pem /opt/vault/tls/vault-ca-cert.pem
    chown root:vault /opt/vault/tls/vault-c-key.pem
    chmod 0644 /opt/vault/tls/vault-c-cert.pem /opt/vault/tls/vault-ca-cert.pem
    chmod 0640 /opt/vault/tls/vault-c-key.pem
    ```

12) Теперь, когда для каждой из нод готовы сертификаты. Перейдем к конфигурации Vault. Отредактируем конфигурационный файл vault для первой ноды vault-a.open.lab: ```nano /etc/vault.d/vault.hcl```
    ```
    mv /etc/vault.d/vault.hcl /etc/vault.d/vault.hcl_original
    ```
    ```
    cluster_addr  = "https://192.168.95.24:8201"
    api_addr      = "https://192.168.95.24:8200"
    disable_mlock = true

    ui = true

    listener "tcp" {
      address            = "0.0.0.0:8200"
      tls_ca_cert_file   = "/opt/vault/tls/vault-ca-cert.pem"
      tls_cert_file      = "/opt/vault/tls/vault-a-cert.pem"
      tls_key_file       = "/opt/vault/tls/vault-a-key.pem"

    }

    storage "raft" {
      path    = "/opt/vault/data"
      node_id = "vault-a.open.lab"

      retry_join {
        leader_tls_servername   = "vault-a.open.lab"
        leader_api_addr         = "https://192.168.95.24:8200"
        leader_ca_cert_file     = "/opt/vault/tls/vault-ca-cert.pem"
        leader_client_cert_file = "/opt/vault/tls/vault-a-cert.pem"
        leader_client_key_file  = "/opt/vault/tls/vault-a-key.pem"
      }
      retry_join {
        leader_tls_servername   = "vault-b.open.lab"
        leader_api_addr         = "https://192.168.95.25:8200"
        leader_ca_cert_file     = "/opt/vault/tls/vault-ca-cert.pem"
        leader_client_cert_file = "/opt/vault/tls/vault-a-cert.pem"
        leader_client_key_file  = "/opt/vault/tls/vault-a-key.pem"
      }
      retry_join {
        leader_tls_servername   = "vault-c.open.lab"
        leader_api_addr         = "https://192.168.95.26:8200"
        leader_ca_cert_file     = "/opt/vault/tls/vault-ca-cert.pem"
        leader_client_cert_file = "/opt/vault/tls/vault-a-cert.pem"
        leader_client_key_file  = "/opt/vault/tls/vault-a-key.pem"
      }
    }
    ```

14) Отредактируем конфигурационный файл vault для первой ноды vault-a.open.lab: ```nano /etc/vault.d/vault.hcl```
    ```
    mv /etc/vault.d/vault.hcl /etc/vault.d/vault.hcl_original
    ```
    ```
    cluster_addr  = "https://192.168.95.25:8201"
    api_addr      = "https://192.168.95.25:8200"
    disable_mlock = true

    ui = true

    listener "tcp" {
      address            = "0.0.0.0:8200"
      tls_ca_cert_file   = "/opt/vault/tls/vault-ca-cert.pem"
      tls_cert_file      = "/opt/vault/tls/vault-b-cert.pem"
      tls_key_file       = "/opt/vault/tls/vault-b-key.pem"

    }

    storage "raft" {
      path    = "/opt/vault/data"
      node_id = "vault-b.vmik.lab"

      retry_join {
        leader_tls_servername   = "vault-a.vmik.lab"
        leader_api_addr         = "https://192.168.95.24:8200"
        leader_ca_cert_file     = "/opt/vault/tls/vault-ca-cert.pem"
        leader_client_cert_file = "/opt/vault/tls/vault-b-cert.pem"
        leader_client_key_file  = "/opt/vault/tls/vault-b-key.pem"
      }
      retry_join {
        leader_tls_servername   = "vault-b.vmik.lab"
        leader_api_addr         = "https://192.168.95.25:8200"
        leader_ca_cert_file     = "/opt/vault/tls/vault-ca-cert.pem"
        leader_client_cert_file = "/opt/vault/tls/vault-b-cert.pem"
        leader_client_key_file  = "/opt/vault/tls/vault-b-key.pem"
      }
      retry_join {
        leader_tls_servername   = "vault-c.vmik.lab"
        leader_api_addr         = "https://192.168.95.26:8200"
        leader_ca_cert_file     = "/opt/vault/tls/vault-ca-cert.pem"
        leader_client_cert_file = "/opt/vault/tls/vault-b-cert.pem"
        leader_client_key_file  = "/opt/vault/tls/vault-b-key.pem"
      }
    }  

    ```
    



































   
