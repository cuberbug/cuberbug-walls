#!/usr/bin/env bash

# Определяет директорию исполняемого файла и переходит в неё
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo -e "Сохранить: SCRIPT_DIR: ${SCRIPT_DIR}"

# Подключает конфигурацию с декором, проверками и переменными
if [[ -d "$SCRIPT_DIR" ]]; then
    source "${SCRIPT_DIR}/tools/scripts/config.sh"
else
    echo "Не удалось подключить config.sh." >&2
    exit 1
fi


# Выводит найденный терминал и запускает в нём скрипт
echo -e "${DECOR_BLUE} ${BOLD}Для запуска используется терминал:${RESET} $TERMINAL"
$TERMINAL -e "$REPO_ROOT/tools/scripts/pull.sh"
