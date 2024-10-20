#!/usr/bin/bash

# Подключает конфигурацию с проверками и переменными
source "$(dirname "$0")/scripts/config.sh"

if [[ $# -eq 0 ]]; then
    echo -e "\e[1;94m::\e[0m \e[1mПоддерживаются аргументы:\e[0m $0 [опции для git push]"
else
    echo -e "\e[1;94m::\e[0m \e[1mgit push выполнится со следующими опциями:\e[0m $@"
fi

# Выводит найденный терминал и запускает в нём скрипт
echo -e "\e[1;94m::\e[0m \e[1mДля запуска используется терминал:\e[0m $TERMINAL"
$TERMINAL -e "$REPO_ROOT/scripts/push.sh" "${@}"
