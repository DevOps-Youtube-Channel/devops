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

5) Создадим ingress с ssl сертификатом
   ```
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: tic-tac-toe-ingress
     namespace: farrukh
     annotations:
       cert-manager.io/cluster-issuer: "letsencrypt-farrukh-prod"
   spec:
     ingressClassName: nginx
     tls:
     - hosts:
       - tictac-f-sadatov.sts404.uz
       secretName: tic-tac-toe-tls
     rules:
     - host: tictac-f-sadatov.sts404.uz
       http:
         paths:
         - path: /
           pathType: Prefix
           backend:
             service:
               name: tictactoe-ssl
               port:
                 number: 80
      ```

6) Проверим
   ```
   kubectl get ingress -n farrukh
   kubectl get certificate -n farrukh
   kubectl describe certificate tic-tac-toe-tls -n farrukh
   kubectl get secret -n farrukh
   ```























