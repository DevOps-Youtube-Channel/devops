#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
source "$DIR/common.sh"

DOCKER_COMPOSE=docker-compose

# Проверки
h2 "[STOP]: checking docker and docker-compose..."
check_docker
check_dockercompose

# Остановка
h2 "[STOP]: stopping Harbor ..."
$DOCKER_COMPOSE down

