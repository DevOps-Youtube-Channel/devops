1) Первым делом проверим установлен ли cert-manager  ```kubectl get cert-manager```

2) Задеплоим приложения
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tictactoe-ssl
  namespace: farrukh
  labels:
    app: tictactoe-ssl
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tictactoe-ssl
  template:
    metadata:
      labels:
        app: tictactoe-ssl
    spec:
      containers:
      - name: tic-tac-toe
        image: m2yy5eu3z/tic-tac-toe:arm64
  ```
