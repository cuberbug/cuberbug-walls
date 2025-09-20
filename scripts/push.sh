#!/usr/bin/bash

# Определяет корневую директорию репозитория и переходит в неё
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1

# Подключает декор
source "${REPO_ROOT}/scripts/config.sh"


## Взаимодействие с Git
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo -e "${DECOR_BLUE} ${FG_YELLOW}Нет изменений для коммита.${RESET}"
else
    DATE_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
    echo -e "${DECOR_BLUE} Создание коммита"
    git add .
    git commit -m "Auto: $DATE_TIME"
fi

echo -e "${DECOR_BLUE} Сохранение и отправка изменений"
if ! git push "$@"; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось выполнить push."
    echo -e "${FG_GREEN}Доступен ввод команд:${RESET} >>"
    exec bash
fi


## Завершение
echo -e "${DECOR_BLUE} ${DECOR_SUCCESS}"
echo -e "${BOLD}Нажмите любую клавишу для закрытия окна:${RESET}"
read -n 1 -s -r
