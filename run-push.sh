#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Функция для поиска первого доступного терминала из списка
find_terminal() {
    local terminals_to_check=("konsole" "gnome-terminal" "alacritty" "kitty" "gnome-console" "xterm")

    for terminal in "${terminals_to_check[@]}"; do
        if command -v "$terminal" &>/dev/null; then
            echo "$terminal"
            return 0
        fi
    done

    return 1
}

# Определяет корневую директорию репозитория и терминал для запуска основной логики
REPO_ROOT="$(git rev-parse --show-toplevel)"
TARGET_SCRIPT="${REPO_ROOT}/tools/git-manager/push.sh"
TERMINAL=$(find_terminal)

if [[ -z "$TERMINAL" ]]; then
    echo "Ошибка: Не удалось найти поддерживаемый эмулятор терминала." >&2
    exit 1
fi

# Запускает скрипт с основной логикой в новом окне терминала, передавая ему все аргументы ($@)
# Например, для команды `run-push.sh --force` аргумент `--force` будет передан в `git push`.
echo ":: Запуск push-сценария в новом окне ($TERMINAL)..."
$TERMINAL -e "$TARGET_SCRIPT" "$@"
