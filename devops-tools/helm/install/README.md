### HELM

Для того чтобы созать Helm Chart сначала нужно установить Helm: https://helm.sh/docs/intro/install/



helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update  
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace --values values.yaml
