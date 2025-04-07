1) Первым делом проверим установлен ли cert-manager  ```kubectl get cert-manager```

2) Задеплоим приложения tictactoe-deployment.yaml
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
3) Создадим service к deployment
   ```
   apiVersion: v1
   kind: Service
   metadata:
     name: tictactoe-ssl
     namespace: farrukh
   spec:
     type: ClusterIP
     selector:
       app: tictactoe-ssl
   ports:
     - port: 80
       targetPort: 3000
       protocol: TCP
    ```

4) Установим ClusterIssuer для Let's Encrypt
   ```
   apiVersion: cert-manager.io/v1
   kind: ClusterIssuer
   metadata:
     name: letsencrypt-farrukh-prod
   spec:
     acme:
       email: admin@gmail.com  # Укажи свою почту
       server: https://acme-v02.api.letsencrypt.org/directory
       privateKeySecretRef:
         name: letsencrypt-farrukh-prod
       solvers:
       - http01:
           ingress:
             class: nginx

   ```

























