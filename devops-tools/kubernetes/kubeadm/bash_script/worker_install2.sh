#!/bin/bash

set -e

echo "[1/8] Обновление пакетов и установка зависимостей..."
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

echo "[2/8] Установка Kubernetes компонентов..."
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[3/8] Отключение swap и настройка sysctl..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Модули для containerd
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

echo "[4/8] Настройка hostname и hosts..."
sudo hostnamectl set-hostname master-node
echo "192.168.95.24 worker-node" | sudo tee -a /etc/hosts

echo "[5/8] Настройка cgroup-driver и kubelet..."
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false --cgroup-driver=systemd"
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart kubelet

echo "[6/8] Отключение плагина cri в containerd..."
# Отключаем plugin cri в конфигурации containerd
sudo sed -i 's/^#\s*\(disabled_plugins\s*=\s*\[\"cri\"\]\)/\1/' /etc/containerd/config.toml
sudo systemctl restart containerd

echo "[7/8] Присоединение к кластеру (используя kubeadm join)..."
# Получаем команду для присоединения к кластеру из master-ноды
echo "Получите команду для присоединения к кластеру с master-ноды, выполнив следующую команду на master-ноде:"
echo "kubeadm token create --print-join-command"
echo "После получения токена и хеша, выполните команду join ниже на worker-ноде."

# Пример команды:
# sudo kubeadm join --token <token> <master-ip>:6443 --discovery-token-ca-cert-hash sha256:<hash>

echo "[8/8] Проверка состояния Worker-ноды..."
# Получаем информацию о статусе kubelet
sudo systemctl status kubelet

echo ""
echo "✅ Установка завершена. Проверьте статус ноды на master-ноде с помощью команды:"
echo "kubectl get nodes"
