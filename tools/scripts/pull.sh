#!/usr/bin/env bash

# Определяет директорию исполняемого файла и переходит в неё
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SCRIPT_DIR="$(dirname "$0")"

# Подключает конфигурацию с декором, проверками и переменными
if ! source "${SCRIPT_DIR}/config.sh"; then
    echo "Не удалось подключить decor.sh." >&2
    exit 1
fi


# === Git === #

# Определяет корневую директорию репозитория и переходит в неё
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1


git status

if confirm "Обновить локальный репозиторий"; then
    echo -e "${DECOR_BLUE} Загрузка актуального состояния репозитория."
    if ! git pull "$@"; then
        echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось выполнить pull."
        echo -e "${FG_GREEN}Доступен ввод команд:${RESET} >>"
        exec bash
    fi
    echo -e "${DECOR_BLUE} ${DECOR_SUCCESS}Локальный репозиторий обновлён.${RESET}"
fi else
    echo -e "${DECOR_BLUE} ${DECOR_ERROR}Отмена.${RESET}"
fi


# Завершение
echo -e "${DECOR_BLUE} ${DECOR_SUCCESS}"
echo -e "${BOLD}Нажмите любую клавишу для закрытия окна:${RESET}"
read -n 1 -s -r
