#!/usr/bin/bash

# Подключает конфигурацию с декором, проверками и переменными
source "$(dirname "$0")/scripts/config.sh"

# Проверяет, переданы ли опции: да - выводит оповещение об их использовании, нет - выводит подсказку
if [[ $# -eq 0 ]]; then
    echo -e "${DECOR_BLUE} ${BOLD}Поддерживаются аргументы:${RESET} $0 [опции для git push]"
else
    echo -e "${DECOR_BLUE} ${BOLD}git push выполнится со следующими опциями:${RESET} $@"
fi

# Выводит найденный терминал и запускает в нём скрипт
echo -e "${DECOR_BLUE} ${BOLD}Для запуска используется терминал:${RESET} $TERMINAL"
$TERMINAL -e "$REPO_ROOT/tools/scripts/push.sh" "${@}"
