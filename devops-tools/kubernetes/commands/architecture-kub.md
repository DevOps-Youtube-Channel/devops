                                        POD


1) Как эскпортировать кубконфиг файл в Кубернетесе?  ```export KUBECONFIG=/home/farrukh/config.yaml```
2) Как посмотреть список контекстов к Кубернетесе?  ```kubectl config get-contexts```
3) Как посмотреть список node в Кубернетесе? ```kubectl get nodes```
4) Как посмотреть список namespace в Кубернетесе? ```kubectl get namespaces```
5) Как создать свой namespace? ```kubectl create namespace f-sadatov```
6) Как посмотреть весь список pod-ов в виде json? ```kubectl get pods -o json```
7) Как посмотреть список pod-ов в расширенном формате? ```kubectl get pods -o wide```
8) Как посмотреть статус pod-ов в онлайн режиме? ```kubectl get pods --watch```
9) Как создать pod в Кубернетес под своим namespace nginx-sadatov?  ```kubectl run nginx-sadatov --image nginx:latest --port 80 -n f-sadatov```
10) Как сгенирировать манифест файл для pod-a и записать конфиг файл pod-а в yaml файл? ```kubectl run nginx-sadatov --image nginx:latest --port 80 --dry-run=client -o yaml -n f-sadatov > nginx-sadatov.yaml```
11) Как запустить pod из сгенирированного манифест файла? ```kubectl apply -f nginx-sadatov.yaml```


                                     Deployment
