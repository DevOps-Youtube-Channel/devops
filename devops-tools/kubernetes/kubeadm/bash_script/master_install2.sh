#!/bin/bash

set -e

echo "[1/9] Обновление пакетов и установка Docker..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# Docker GPG ключ и репозиторий
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker && sudo systemctl start docker

echo "[2/9] Настройка Docker cgroup..."
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

echo "[3/9] Добавление Kubernetes репозитория..."
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update

echo "[4/9] Установка Kubernetes тулов..."
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[5/9] Отключение swap и настройка sysctl..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Модули
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Сетевые параметры
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

echo "[6/9] Настройка hostname и hosts..."
sudo hostnamectl set-hostname master-node
echo "192.168.95.24 master-node" | sudo tee -a /etc/hosts

echo "[7/9] Настройка Kubelet..."
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false --cgroup-driver=systemd"
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart kubelet

echo "[8/9] Инициализация master-ноды..."
sudo sed -i 's/^#\s*\(disabled_plugins\s*=\s*\[\"cri\"\]\)/\1/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd
sudo kubeadm init --control-plane-endpoint=master-node --upload-certs --pod-network-cidr=10.244.0.0/16 --cri-socket=/run/containerd/containerd.sock

echo "[9/9] Настройка kubectl и установка Flannel..."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://github.com/cilium/cilium/releases/download/v1.13.0/cilium.yaml
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

echo ""
echo "✅ Установка завершена. Проверь статус:"
kubectl get nodes
