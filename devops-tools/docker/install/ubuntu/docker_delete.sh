#!/bin/bash
clear
echo -e "\n\n❗️❗️❗️❗️❗️ВНИМАНИЕ ОБЯЗАТЕЛЬНО ПРОЧИТАЙТЕ❗️❗️❗️❗️❗️\n\nДобро пожаловать в удаление Docker 😊\n"
docker_version=$(docker --version | awk '{print $3}' | cut -d ',' -f 1)
echo -e "\nУ вас установлен Docker версии: $docker_version\n"
echo -e "Вы точно хотите удалить Docker? (y/n) ❓\n"

read -p "Введите 'y' для подтверждения или 'n' для отмены: " choice

if [[ "$choice" == "y" || "$choice" == "yes" ]]; then
  echo -e "\nНачинаем удаление Docker...\n"
  sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
  sudo rm -rf /var/lib/docker
  sudo rm -rf /var/lib/containerd
  sudo rm /etc/apt/sources.list.d/docker.list
  sudo rm /etc/apt/keyrings/docker.asc
  echo -e "\nDocker успешно удалён с системы.\n"
else
  echo -e "\nУдаление Docker отменено.\n"
fi
