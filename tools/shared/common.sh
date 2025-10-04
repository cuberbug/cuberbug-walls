#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Определяет директорию, в которой лежит этот (common.sh) скрипт
# Это нужно, чтобы надёжно подключать другие файлы (decor.sh, utils.sh)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# --- Подключение зависимостей ---

# Подключает декор и утилиты, с проверкой на существование файлов
source "${SCRIPT_DIR}/decor.sh" || { echo "Ошибка: не найден decor.sh" >&2; exit 1; }
source "${SCRIPT_DIR}/utils.sh" || { echo "Ошибка: не найден utils.sh" >&2; exit 1; }


# --- Проверки окружения ---

# Проверяет, что Git установлен
if ! command -v git &>/dev/null; then
    echo -e "${DECOR_ERROR} Git не установлен." >&2
    exit 1
fi

# Проверяет, что находится внутри Git-репозитория
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo -e "${DECOR_ERROR} Не найден Git-репозиторий." >&2
    exit 1
fi


# --- Глобальные переменные ---

# Определяет корневую директорию репозитория
# Эта переменная будет доступна во всех скриптах, которые подключат common.sh
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Экспорт переменных для доступа в дочерних процессах, если понадобится
export REPO_ROOT
