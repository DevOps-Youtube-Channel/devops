###                                                              Docker

1) Как собрать докер образ под arm64? ```docker buildx create --use && docker buildx build --platform linux/arm64 -t flask-app:v1 --load .```
2) Как отправить готовый докер образ в Docker Hub? ```docker login -u farrukhit && docker tag todo:v2 farrukhit/todo:v2 && docker push farrukhit/todo:v2```
                                        
                                        
   ### POD


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


### Deployment
1) Как запустить deployment под своим namespace-ом?  ```kubectl create deploy tic-tac-toe --image m2yy5eu3z/tic-tac-toe:arm64 --replicas 1 --port 3000 -n f-sadatov```
2) Как посмотреть список deployment? ```kubectl get deployment -n f-sadatov```
3) Как посмотреть список replicaset? ```kubectl get replicaset -n f-sadatov```
4) Как посмотреть список pod-ов? ```kubectl get pods -n f-sadatov```
5) Как увеличить количество реплик deployment? ```kubectl scale deploy tic-tac-toe --replicas 5 -n f-sadatov```
6) Как сгенирировать deployment файл и записать в yaml файл? ```kubectl create deploy tic-tac-toe --image m2yy5eu3z/tic-tac-toe:arm64 --replicas 1 --port 3000 -n f-sadatov --dry-run=client -o yaml > tic-tac-toe-deployment.yaml```
7) Как посмотреть статус pod-a? ```kubectl describe pod tic-tac-toe-7474ff488c-bsqzz -n f-sadatov```
8) Как опубликовать deployment через Service? ```kubectl expose deployment flask-app --port 80 --target-port 5000 -n f-sadatov```
9) Как посмотреть список Service? ```kubectl get service -n f-sadatov```
10) Как зайти внутрь pod-a ? ```kubectl -n f-sadatov exec -it nginx -- bash```
11) Как опубликовать deployment через NodePort? ```kubectl expose deployment nginx-arm --port 80 --target-port 80 --type NodePort -n f-sadatov```
13) Как изменить deployment файл напрямую из CLI? ```kubectl edit deployment/nginx-deploy```
14) Как обновить версию nginx через императивным способом? ```kubectl set image deployment/my-deployment my-container=nginx:1.19.2```

### Ingress
1) Как установить ingress-controller чтобы он слушал hostnetwork+hostport: ```ingress-values.yaml```
   ```
   controller:
   hostNetwork: true
   daemonSet: true
   hostPort:
     enabled: true
     ports:
       http: 80
       https: 443
   service:
     type: ClusterIP
   admissionWebhooks:
     enabled: false
   ```

   Теперь можно установить ingress-controller с помощью созданного выше ingress-values.yaml файла:
   ```
   helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace -f ingress-values.yaml
   ```


3) Как создать ingress?
   ```
   kubectl create ingress flaskapp-clusterip-ingress --rule="f-sadatov.sts404.uz/*=cluster-ip-service:80" --class nginx -n f-sadatov --dry-run=client -o yaml > ingress.yaml
   ```
   Не забудь добавить добавить в поле spec следующий запись:   ingressClassName: nginx

### Check
1) Для проверки какого то запроса какой образ использовать ? ```kubectl run check-pod --image nicolaka/netshoot -n exam-farrukh -- sleep infinity```
