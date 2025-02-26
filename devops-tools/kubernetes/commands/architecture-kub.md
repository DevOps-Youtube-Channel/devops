1) Как посмотреть список контекстов к Кубернетесе?
   ```kubectl config get-contexts```
2) Как создать pod в дефольтном namespace?
   ```kubectl run nginx-sadatov --image nginx:latest --port 80 -n```
3) Как создать pod в Кубернетес под своим namespace?
   ```kubectl run nginx-sadatov --image nginx:latest --port 80 -n f-sadatov```
