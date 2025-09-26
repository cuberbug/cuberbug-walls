#!/usr/bin/env bash

# Определяет директорию исполняемого файла и переходит в неё
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Подключает конфигурацию с декором, проверками и переменными
if ! source "${SCRIPT_DIR}/tools/scripts/config.sh"; then
    echo "Не удалось подключить config.sh." >&2
    exit 1
fi


# Выводит найденный терминал и запускает в нём скрипт
echo -e "${DECOR_BLUE} ${BOLD}Для запуска используется терминал:${RESET} $TERMINAL"
$TERMINAL -e "$REPO_ROOT/tools/scripts/pull.sh"
