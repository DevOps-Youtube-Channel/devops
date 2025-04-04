Порты которые должны быть открыты

Control Plane Node
kube-controller manager : 10257
kubernets API server : 6443
kubelet API : 10250
kube-scheduler : 10259
etcd API : 2379 / 2380

Worker Node
kubelet API : 10250
NodePort port range : 30000–32767

Отключаем файервол
sudo ufw disable
sudo ufw status

1) Обновим список пакетов
sudo apt update
sudo apt -y full-upgrade

2) Установим время
sudo apt install systemd-timesyncd
sudo timedatectl set-ntp true
sudo timedatectl status

3) Установим hostname
sudo hostnamectl set-hostname master-node
nano /etc/hosts
192.168.95.24 master-node

3) Отключим swap
sudo swapoff -a
sudo sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab
free -m
cat /etc/fstab | grep swap

4) Подготовым ядро
sudo vim /etc/modules-load.d/k8s.conf
overlay
br_netfilter

sudo modprobe overlay modprobe br_netfilter
lsmod | grep "overlay\|br_netfilter"

5) Сетевые настройки
sudo vim /etc/sysctl.d/k8s.conf

net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1

sudo sysctl --system

6) Установим софты
sudo apt-get install -y apt-transport-https ca-certificates curl gpg gnupg2 software-properties-common

7) Установим тулы Кубернетес
sudo mkdir -m 755 /etc/apt/keyrings
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
lsmod | grep "overlay\|br_netfilter"

8) Установим Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable"
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

9) Установим Containerd
sudo apt update
sudo apt install -y containerd.io
sudo mkdir -p /etc/containerd
sudo containerd config default|sudo tee /etc/containerd/config.toml


runtime_type = "io.containerd.runc.v2"  # <- note this, this line might have been missed
SystemdCgroup = true # <- note this, this could be set as false in the default configuration, please make it true
disabled_plugins = []


sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status containerd

10) Установим доп функции crictl
 sudo crictl ps
 sudo apt install cri-tools
 sudo vim /etc/crictl.yaml
 
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: true # <- if you don't want to see debug info you can set this to false
pull-image-on-create: false

sudo crictl ps

11) Включим kubelet 
sudo systemctl enable kubelet

12) Инициализируем мастер нод
sudo crictl images
sudo kubeadm config images pull --cri-socket unix:///var/run/containerd/containerd.sock
sudo crictl images

13) Инициализируем мастер нод
sudo systemctl restart containerd
sudo systemctl restart kubelet
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock --v=5

14) Создадим кубконфиг
 mkdir -p $HOME/.kube
 sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 sudo chown $(id -u):$(id -g) $HOME/.kube/config
 export KUBECONFIG=/etc/kubernetes/admin.conf
 kubectl get nodes

 15) Печатать токен у мастера
 kubeadm token create --print-join-command
 kubeadm join 192.168.8.120:6443 — token dg67p7.wvt7n5zxx9pxbmaz — discovery-token-ca-cert-hash sha256:36f9eb64ef8a6d45254b8994108b0e3a56e856bcb3b07d46cd83554db4114490

 16) Посмотреть список нодов
 kubectl get nodes -o wide
