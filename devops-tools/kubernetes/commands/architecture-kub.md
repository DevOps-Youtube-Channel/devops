1) Как эскпортировать кубконфиг файл в Кубернетесе?
    ```export KUBECONFIG=/home/farrukh/config.yaml```
   
2) Как посмотреть список контекстов к Кубернетесе?
   ```kubectl config get-contexts```
   
3) Как посмотреть список node в Кубернетесе?
   ```kubectl get nodes```
   
4) Как посмотреть список namespace в Кубернетесе?
   ```kubectl get namespaces```
   
5) Как создать pod в default namespace под названием nginx-sadatov?  ```kubectl run nginx-sadatov --image nginx:latest --port 80 -n```
   
6) Как создать pod в Кубернетес под своим namespace nginx-sadatov?  ```kubectl run nginx-sadatov --image nginx:latest --port 80 -n f-sadatov```
   
7) 
