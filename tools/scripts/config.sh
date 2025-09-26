#!/usr/bin/env bash

# Определяет директорию исполняемого файла и переходит в неё
SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo -e "config: SCRIPT_DIR: ${SCRIPT_DIR}"
cd "$SCRIPT_DIR" || exit 1

# Подключает декор: набор констант для оформления выводимого текста
if ! source "${SCRIPT_DIR}/decor.sh"; then
    echo "Не удалось подключить decor.sh." >&2
    exit 1
fi

# Подключает дополнительные инструменты
# TERMINAL: переменная, в которой записан путь до бинаркика первого найденного эмулятора терминала.
# confirm "str": Обёртка, которая запрашивает подтверждение выполняемых действий (по умолчанию "Y").
# refuse "str": Обёртка, аналогичная confirm, только со значением по умолчанию "N".
if ! source "${SCRIPT_DIR}/utils.sh"; then
    echo "Не удалось подключить utils.sh." >&2
    exit 1
fi

TERMINAL="${TERMINAL:-$(command -v konsole || command -v gnome-console || command -v gnome-terminal || command -v alacritty || command -v xterm)}"


# Проверяет, найден ли эмулятор
if [ -z "$TERMINAL" ]; then
    echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось найти поддерживаемый эмулятор терминала."
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
