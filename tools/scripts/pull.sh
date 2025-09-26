#!/usr/bin/env bash

# Определяет корневую директорию репозитория и переходит в неё
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Подключает конфигурацию с декором, проверками и переменными
if [[ -d "$SCRIPT_DIR" ]]; then
    source "${SCRIPT_DIR}/config.sh"
else
    echo "Не удалось подключить config.sh" >&2
    exit 1
fi

# Подключает дополнительные инструменты
# TERMINAL: переменная, в которой записан путь до бинаркика первого найденного эмулятора терминала.
# confirm "str": Обёртка, которая запрашивает подтверждение выполняемых действий (по умолчанию "Y").
# refuse "str": Обёртка, аналогичная confirm, только со значением по умолчанию "N".
if [[ -d "$SCRIPT_DIR" ]]; then
    source "${SCRIPT_DIR}/utils.sh"
else
    echo "Не удалось подключить utils.sh" >&2
    exit 1
fi


# === Git === #

# Определяет корневую директорию репозитория и переходит в неё
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1


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


# Завершение
echo -e "${DECOR_BLUE} ${DECOR_SUCCESS}"
echo -e "${BOLD}Нажмите любую клавишу для закрытия окна:${RESET}"
read -n 1 -s -r
