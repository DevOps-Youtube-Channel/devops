### HELM

Для того чтобы созать Helm Chart сначала нужно установить Helm: ```https://helm.sh/docs/intro/install/```

1) Создадим папку для работы: ```helm create helm-task```
2) Cкопируем values.yaml по другим именем: ```cp values.yaml values-helm.yaml```
3) Деплоим сервис: ```helm install helm-test-farrukh ../helm-task --values values-helm.yaml -n helm-farrukh```


