#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
source "$DIR/common.sh"

DOCKER_COMPOSE=docker-compose

# Проверки
h2 "[Step 0]: checking if docker is installed ..."
check_docker

h2 "[Step 1]: checking docker-compose is installed ..."
check_dockercompose

# Загрузка образов
if ls harbor*.tar.gz &>/dev/null; then
    h2 "[Step 2]: loading Harbor images ..."
    docker load -i ./harbor*.tar.gz
fi

# Подготовка конфигов
h2 "[Step 3]: preparing harbor configs ..."
prepare_para=""
if [ "$1" == "--with-trivy" ]; then
    prepare_para="--with-trivy"
fi

./prepare $prepare_para

# Запуск
h2 "[Step 4]: starting Harbor ..."
$DOCKER_COMPOSE up -d

success "----Harbor has been started successfully.----"
