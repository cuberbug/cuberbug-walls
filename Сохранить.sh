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


# Проверяет, переданы ли опции: да - выводит оповещение об их использовании, нет - выводит подсказку
if [[ $# -eq 0 ]]; then
    echo -e "${DECOR_BLUE} ${BOLD}Поддерживаются аргументы:${RESET} $0 [опции для git push]"
else
    echo -e "${DECOR_BLUE} ${BOLD}git push выполнится со следующими опциями:${RESET} $@"
fi

# Выводит найденный терминал и запускает в нём скрипт
echo -e "${DECOR_BLUE} ${BOLD}Для запуска используется терминал:${RESET} $TERMINAL"
echo -e "REPO_ROOT: $REPO_ROOT"
$TERMINAL -e "$REPO_ROOT/tools/scripts/push.sh" "${@}"
