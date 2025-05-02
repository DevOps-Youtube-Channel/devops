### HELM

Для того чтобы созать Helm Chart сначала нужно установить Helm: ```https://helm.sh/docs/intro/install/```

1) Создадим папку для работы: ```helm create helm-task```
2) Cкопируем values.yaml по другим именем: ```cp values.yaml values-helm.yaml```
3) Деплоим сервис: ```helm install helm-test-farrukh ../helm-task --values values-helm.yaml -n helm-farrukh```

### PUSH
```
helm package --version 1.1.0 .
curl --request POST --form 'chart=@microservice_v2-1.1.0.tgz' --user helm-user:token https://gitlab.zafarsaidov.uz/api/v4/projects/3/packages/helm/api/stable/charts
helm repo add --username helm-user --password token microservice https://gitlab.zafarsaidov.uz/api/v4/projects/3/packages/helm/stable
helm push microservice-1.1.0.tgz microservice_v2
```


