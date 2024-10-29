#!/usr/bin/bash

# Подключает оформление
source "$(dirname "$0")/scripts/decor.sh"

# Пытается найти эмулятор терминала
TERMINAL="${TERMINAL:-$(command -v alacritty || command -v konsole || command -v gnome-terminal || command -v xterm)}"

# Проверяет, найден ли эмулятор
if [ -z "$TERMINAL" ]; then
    echo -e "${BLUE_DECOR} ${ERROR_DECOR} Не удалось найти эмулятор терминала."
    exit 1
fi

# Проверяет, что Git установлен
if ! command -v git &>/dev/null; then
    echo -e "${BLUE_DECOR} ${ERROR_DECOR} Git не установлен."
    exit 1
fi

# Проверяет, что находится в Git-репозитории
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo -e "${BLUE_DECOR} ${ERROR_DECOR} Не найден Git-репозиторий."
    exit 1
fi

# Определяет корневую директорию репозитория
REPO_ROOT="$(git rev-parse --show-toplevel)"
