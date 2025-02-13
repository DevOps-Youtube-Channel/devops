1) Первый очередь поднимем все виртуальные машины
   ```
   Master-Node-1	  192.168.95.15   CPU-2 RAM-4GB   Ubuntu-22.04
   Master-Node-2	  192.168.95.16   CPU-2 RAM-4GB   Ubuntu-22.04
   Master-Node-3	  192.168.95.17   CPU-2 RAM-4GB   Ubuntu-22.04
   Worker-Node-1	  192.168.95.18   CPU-2 RAM-4GB   Ubuntu-22.04
   Worker-Node-2	  192.168.95.19   CPU-2 RAM-4GB   Ubuntu-22.04
   Worker-Node-3	  192.168.95.20   CPU-2 RAM-4GB   Ubuntu-22.04
   ```

2) Для создания кластера Kubespray создадим еще одну виртуальную машину чтобы управлять через Ansible
   ```
   Ansible-Node     192.168.95.21   CPU-2 RAM-4GB   Ubuntu-22.04
   ```

3) Сгенирируем ssh ключ у Ansible-Node
   ```
   ssh-keygen -t rsa
   ```
4) Копируем созданный ключ хостам c Ansible-Node
   ```
   ssh-copy-id 192.168.95.15
   ssh-copy-id 192.168.95.16
   ssh-copy-id 192.168.95.17
   ssh-copy-id 192.168.95.18
   ssh-copy-id 192.168.95.19
   ssh-copy-id 192.168.95.20 
   ```
   
