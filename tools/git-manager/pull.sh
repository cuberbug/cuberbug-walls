#!/usr/bin/env bash

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1


# --- Git ---

git status

if confirm "Обновить локальный репозиторий"; then
    echo -e "${DECOR_BLUE} Загрузка актуального состояния репозитория..."
    if ! git pull "$@"; then
        echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось выполнить pull"
        echo -e "${FG_GREEN}Доступен ввод команд:${RESET} >>"
        exec bash
    fi
    echo -e "${DECOR_BLUE} ${FG_GREEN}Локальный репозиторий обновлён${RESET}"
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Отмена${RESET}"
fi


# --- Завершение ---

echo -e "${BOLD}Нажмите любую клавишу для закрытия окна:${RESET}"
read -n 1 -s -r
