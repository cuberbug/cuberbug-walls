#!/usr/bin/bash

# Определяет корневую директорию репозитория и переходит в неё
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1

# Подключает декор
source "${REPO_ROOT}/scripts/config.sh"


## Взаимодействие с Git
echo -e "${BLUE_DECOR} Загрузка актуального состояния репозитория."
if ! git pull "$@"; then
    echo -e "${BLUE_DECOR} ${ERROR_DECOR} Не удалось выполнить pull."
    echo -e "${D_GREEN}Доступен ввод команд:${D_CANCEL} >>"
    exec bash
fi


## Завершение
echo -e "${BLUE_DECOR} ${COMPLETE_DECOR}"
echo -e "${D_BOLD}Нажмите любую клавишу для закрытия окна:${D_CANCEL}"
read -n 1 -s -r
