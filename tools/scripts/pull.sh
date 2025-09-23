#!/usr/bin/bash

# Определяет корневую директорию репозитория и переходит в неё
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1

# Подключает декор
source "${REPO_ROOT}/tools/scripts/config.sh"


## Взаимодействие с Git
echo -e "${DECOR_BLUE} Загрузка актуального состояния репозитория."
if ! git pull "$@"; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось выполнить pull."
    echo -e "${FG_GREEN}Доступен ввод команд:${RESET} >>"
    exec bash
fi


## Завершение
echo -e "${DECOR_BLUE} ${DECOR_SUCCESS}"
echo -e "${BOLD}Нажмите любую клавишу для закрытия окна:${RESET}"
read -n 1 -s -r
