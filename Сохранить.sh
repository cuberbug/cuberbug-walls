#!/usr/bin/bash

# Подключает конфигурацию с декором, проверками и переменными
source "$(dirname "$0")/scripts/config.sh"

if [[ $# -eq 0 ]]; then
    echo -e "${BLUE_DECOR} ${D_BOLD}Поддерживаются аргументы:${D_CANCEL} $0 [опции для git push]"
else
    echo -e "${BLUE_DECOR} ${D_BOLD}git push выполнится со следующими опциями:${D_CANCEL} $@"
fi

# Выводит найденный терминал и запускает в нём скрипт
echo -e "${BLUE_DECOR} ${D_BOLD}Для запуска используется терминал:${D_CANCEL} $TERMINAL"
$TERMINAL -e "$REPO_ROOT/scripts/push.sh" "${@}"
