#!/bin/bash
clear
echo -e "\n\n❗️❗️❗️❗️❗️ВНИМАНИЕ ОБЯЗАТЕЛЬНО ПРОЧИТАЙТЕ❗️❗️❗️❗️❗️\n\nДобро пожаловать в установку Docker 😊\n"

# Проверка, установлен ли Docker в системе
if command -v docker &> /dev/null; then
  echo "Docker уже установлен на этом сервере. Завершаем установку ✋ "
  docker_version=$(docker --version | awk '{print $3}' | cut -d ',' -f 1)
  echo -e "Установленная версия Docker: $docker_version\n"
  exit 0
fi
echo "Проверим, запускается ли скрипт от имени root пользователя...🔄"

# Проверка, выполняется ли скрипт с правами суперпользователя
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами root 🤖(например, с помощью sudo)"
  exit 1
else
  echo -e "Скрипт запущен с правами root. Можем продолжать 😊\n"
fi

# Определение ОС и семейства
echo "Определяем ваша ОС...🔄 "
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
  VERSION_ID=$VERSION_ID
else
  echo "Невозможно определить операционную систему ⛔️  ➡️ Этот скрипт поддерживает только системы на основе Debian, Red Hat и Arch ⬅️"
  exit 1
fi
echo "ОС определена: $PRETTY_NAME  🆒"

# Установка репозитория Docker
add_docker_repo() {
  apt-get update
  apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  install -m 0755 -d /etc/apt/keyrings

  # Добавление ключа и репозитория Docker
  curl -fsSL https://download.docker.com/linux/$OS/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
}

# Установка стабильной версии Docker
install_docker_debian() {
  add_docker_repo
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Установка конкретной версии Docker
install_docker_debian_specific() {
  version=$1
  add_docker_repo
  sudo apt-get install -y docker-ce="$version" docker-ce-cli="$version" containerd.io docker-buildx-plugin docker-compose-plugin
}

# Ввод пользователя для выбора версии Docker
echo -e "\nУстановить последнюю стабильную версию Docker или указать конкретную версию ❓"
while true; do
 read -p "Введите 'stable' для последней стабильной версии или 'specific' для установки определённой версии: " choice

 if [ "$choice" == "stable" ]; then
  echo -e "\nВы выбрали установку последнюю стабильную версию Docker\n\nВнимание❗️❗️❗️ Начинается установка ✅\n"
  install_docker_debian
  break
 elif [ "$choice" == "specific" ]; then
  echo -e "\nВы выбрали установку определённой версии Docker\n\nВнимание❗️❗️❗️ Начинается установка ✅\n"
  echo "Обновляем список доступных версий Docker...🔄"
  add_docker_repo

# Запрос конкретной версии
  echo "Доступные версии Docker:"
  apt-cache madison docker-ce | awk '{print $3}'
  echo ""
  read -p "Введите версию Docker (например, 5:20.10.7~3-0~debian-buster): " version
  echo "\nУстанавливаем Docker версии: $version..."
  install_docker_debian_specific "$version"
  break
 else
  echo "Неверный выбор. Пожалуйста, выберите 'stable' или 'specific'."
 fi
done

# Вывод версии установленной Docker
docker_version=$(docker --version | awk '{print $3}' | cut -d ',' -f 1)
echo ""
if [ "$choice" == "stable" ]; then
  echo "Установлена последняя стабильная версия Docker: $docker_version"
else
  echo "Установлена указанная версия Docker: $docker_version"
fi
