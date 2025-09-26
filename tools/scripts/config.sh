#!/usr/bin/env bash

# Определяет директорию исполняемого файла и переходит в неё
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit 1

# Подключает декор: набор констант для оформления выводимого текста
if [[ -d "$SCRIPT_DIR" ]]; then
    source "${SCRIPT_DIR}/decor.sh"
else
    echo "Не удалось подключить decor.sh." >&2
    exit 1
fi


TERMINAL="${TERMINAL:-$(command -v konsole || command -v gnome-console || command -v gnome-terminal || command -v alacritty || command -v xterm)}"


# Проверяет, найден ли эмулятор
if [[ -z "$TERMINAL" ]]; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось найти поддерживаемый эмулятор терминала."
    exit 1
fi

# Проверяет, что Git установлен
if ! command -v git &>/dev/null; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Git не установлен."
    exit 1
fi

# Проверяет, что находится в Git-репозитории
echo -e "git check: SCRIPT_DIR: $SCRIPT_DIR"
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не найден Git-репозиторий."
    exit 1
fi

# Определяет корневую директорию репозитория
REPO_ROOT="$(git rev-parse --show-toplevel)"
