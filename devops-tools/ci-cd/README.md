Как должен выглядит CI/CD ?
Необходимо: 
1) Юзер для Gitlab-Registry ( логин и пароль) 
2) Юзер для Helm-Registry ( логином и токеном)
3) Создать какой то группу
4) Создать репозиторий внутри группы

1) Созадим гуппу в gitlab - ```devops```
2) Создадим проект внутри группы devops - ```tic-tac-toe```
3) Создадим ```.gitlab-ci.yml``` файл
   ```
   stages:
     - build
     - deploy 

   .build:
     stage: build
     image: gitlab.zafarsaidov.uz:5050/devops/docker:arm
     before_script:
       - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
     script: 
       - docker build -t ${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${ENV_TAG} .
       - docker tag ${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${ENV_TAG} ${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${CI_PIPELINE_IID}
       - docker push ${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${ENV_TAG}
       - docker push ${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${CI_PIPELINE_IID}
       - docker rmi ${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${ENV_TAG}
       - docker rmi ${CI_REGISTRY}/${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}:${CI_PIPELINE_IID}

   build_prod:
     extends: .build
     only:
       - main
     variables:
       ENV_TAG: prod
     tags:
       - farrukh-arm

   deploy:
     stage: deploy
     image: gitlab.zafarsaidov.uz:5050/devops/docker:dind
     variables:
       HELM_RELEASE_NAME: flask-api
       VALUES_FILE: .helm/values-prod.yml
       NAMESPACE: production
     script:
       - helm repo add --username $HELM_REGISTRY_USERNAME --password $HELM_REGISTRY_PASSWORD $HELM_REPO_NAME $HELM_REGISTRY_PATH
       - helm upgrade --install $HELM_RELEASE_NAME $HELM_REPO_NAME/$HELM_CHART_NAME --set=image.tag=$CI_PIPELINE_IID --values $VALUES_FILE -n $NAMESPACE
     only:
       - main
   ```


   4) Cоздадим helm package
      ```
      helm package ./tic-tac-toe-helm --version 1.0.0
      curl --request POST --form 'chart=@tic-tac-toe-helm-1.0.0.tgz' --user farrukh-helm-login:token https://gitlab.zafarsaidov.uz/api/v4/projects/31/packages/helm/api/stable/charts

      helm repo add --username helm-user --password token microservice https://gitlab.zafarsaidov.uz/api/v4/projects/3/packages/helm/stable

      helm push microservice-1.1.0.tgz microservice_v2
      ```

   5) Создадим secret на Кубернетесе
      ```
      kubectl create secret docker-registry gitlab-regcred --docker-server=gitlab.zafarsaidov.uz:5050 --docker-username=farrukh-helm-login --docker-password=<pass> --docker-email=farrukh@admin.uz -n helm-farrukh
      ```

