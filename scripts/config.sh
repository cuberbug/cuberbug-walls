#!/usr/bin/bash

# Определяет корневую директорию репозитория
REPO_ROOT="$(git rev-parse --show-toplevel)"
# Пытается найти эмулятор терминала
TERMINAL="${TERMINAL:-$(command -v alacritty || command -v konsole || command -v gnome-console || command -v gnome-terminal || command -v xterm)}"

# Подключает декор
source "${REPO_ROOT}/scripts/decor.sh"


# Проверяет, найден ли эмулятор
if [ -z "$TERMINAL" ]; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось найти эмулятор терминала."
    exit 1
fi

# Проверяет, что Git установлен
if ! command -v git &>/dev/null; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Git не установлен."
    exit 1
fi

# Проверяет, что находится в Git-репозитории
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не найден Git-репозиторий."
    exit 1
fi
