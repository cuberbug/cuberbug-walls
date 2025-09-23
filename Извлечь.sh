#!/usr/bin/bash

# Подключает конфигурацию с декором, проверками и переменными
source "$(dirname "$0")/scripts/config.sh"

# Выводит найденный терминал и запускает в нём скрипт
echo -e "${DECOR_BLUE} ${BOLD}Для запуска используется терминал:${RESET} $TERMINAL"
$TERMINAL -e "$REPO_ROOT/tools/scripts/pull.sh"
