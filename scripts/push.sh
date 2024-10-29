#!/usr/bin/bash

# Определяет корневую директорию репозитория и переходит в неё
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1

# Подключает декор
source "${REPO_ROOT}/scripts/config.sh"


## Взаимодействие с Git
if git diff --quiet && git diff --cached --quiet; then
    echo -e "${BLUE_DECOR} ${D_ORANGE}Нет изменений для коммита.${D_CANCEL}"
else
    DATE_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
    echo -e "${BLUE_DECOR} Создание коммита"
    git add .
    git commit -m "Auto: $DATE_TIME"
fi

echo -e "${BLUE_DECOR} Сохранение и отправка изменений"
if ! git push "$@"; then
    echo -e "${BLUE_DECOR} ${ERROR_DECOR} Не удалось выполнить push."
    exec bash
fi


## Завершение
echo -e "${BLUE_DECOR} ${COMPLETE_DECOR}"
echo -e "${D_BOLD}Нажмите любую клавишу для закрытия окна:${D_CANCEL}"
read -n 1 -s -r
