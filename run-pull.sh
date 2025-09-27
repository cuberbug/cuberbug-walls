#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Функция для поиска первого доступного терминала из списка
find_terminal() {
    # Список терминалов в порядке предпочтения. Легко добавить новые!
    local terminals_to_check=("konsole" "gnome-terminal" "alacritty" "kitty" "gnome-console" "xterm")

    for terminal in "${terminals_to_check[@]}"; do
        # command -v вернёт путь к команде, если она существует
        if command -v "$terminal" &>/dev/null; then
            # Выводим найденный путь и выходим из функции
            echo "$terminal"
            return 0
        fi
    done

    # Если цикл завершился, а мы ничего не нашли, возвращаем ошибку
    return 1
}

# 1. Находим корень репозитория. Если мы не в репо, git вернёт ошибку, и скрипт упадёт.
REPO_ROOT="$(git rev-parse --show-toplevel)"

# 2. Находим эмулятор терминала (минимальная необходимая логика)
TERMINAL=$(find_terminal)

if [[ -z "$TERMINAL" ]]; then
    # Используем >&2 для вывода ошибок в stderr
    echo "Ошибка: Не удалось найти поддерживаемый эмулятор терминала." >&2
    exit 1
fi


# 3. Определяем путь к скрипту, который нужно запустить
TARGET_SCRIPT="${REPO_ROOT}/tools/scripts/pull.sh"

# 4. Запускаем терминал с нашим скриптом.
echo ":: Запуск push-сценария в новом окне ($TERMINAL)..."
$TERMINAL -e "$TARGET_SCRIPT"
