1) Первым делом проверим установлен ли cert-manager  ```kubectl get cert-manager```

2) Задеплоим приложения
   ```
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     creationTimestamp: null
     labels:
       app: tictactoe-ssl
     name: tictactoe-ssl
     namespace: farrukh
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: tictactoe-ssl
     strategy: {}
     template:
       metadata:
         creationTimestamp: null
         labels:
           app: tictactoe-ssl
       spec:
         containers:
         - image: m2yy5eu3z/tic-tac-toe:arm64
           name: tic-tac-toe
   ```
