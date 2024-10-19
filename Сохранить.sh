#!/usr/bin/bash

# Подключает конфигурацию с проверками и переменными
source "$(dirname "$0")/scripts/config.sh"

# Выводит найденный терминал и запускает в нём скрипт
echo -e "\e[1;94m::\e[0m \e[1mДля запуска используется терминал:\e[0m $TERMINAL"
$TERMINAL -e "$REPO_ROOT/scripts/push.sh"
