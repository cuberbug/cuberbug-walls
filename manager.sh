#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Функция для поиска первого доступного терминала из списка
find_terminal() {
    local terminals_to_check=(
        "konsole"        # Многофункциональный терминал для среды KDE
        "gnome-terminal" # Стандартный терминал для среды GNOME
        "gnome-console"  # Легковесный терминал для GNOME, замена gnome-terminal
        "xfce4-terminal" # Легковесный терминал, идущий в комплекте с XFCE
        "kitty"          # Быстрый, настраиваемый терминал с поддержкой GPU
        "alacritty"      # Легковесный, высокопроизводительный терминал с акцентом на простоту
        "xterm"          # Классический, минималистичный терминал для X Window System
    )

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
TARGET_SCRIPT="${REPO_ROOT}/tools/start.sh"
TERMINAL=$(find_terminal)

if [[ -z "$TERMINAL" ]]; then
    echo "Ошибка: Не удалось найти поддерживаемый эмулятор терминала." >&2
    exit 1
fi

# Запускает скрипт с основной логикой в новом окне терминала
echo ":: Запуск интерактивного меню в новом окне ($TERMINAL)..."
$TERMINAL -e "$TARGET_SCRIPT"
