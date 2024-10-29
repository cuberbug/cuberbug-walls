#!/usr/bin/bash

# Подключает конфигурацию с декором, проверками и переменными
source "$(dirname "$0")/scripts/config.sh"

# Выводит найденный терминал и запускает в нём скрипт
echo -e "${BLUE_DECOR} ${D_BOLD}Для запуска используется терминал:${D_CANCEL} $TERMINAL"
$TERMINAL -e "$REPO_ROOT/scripts/pull.sh"
