#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/shared/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1

# Проверяет, что gum установлен
if ! command -v gum &>/dev/null; then
    echo -e "${DECOR_ERROR} Gum не установлен. Этот пакет является обязательной зависимостью для меню." >&2
    exit 1
fi


# --- Настройки меню ---

MENU_OPTIONS=(
    "Выход"                          # [0] Всегда должен быть первым элементом массива
    "Сохранить (git push)"           # [1]
    "Обновить (git pull)"            # [2]
    "Переименовать обои по шаблону"  # [3]
)


# --- Главный цикл меню ---

while true; do
    clear

    # Создаём временный массив для отображения:
    # Сначала все элементы с 1-го до конца, а в конец добавляет 0-й элемент.
    DISPLAY_OPTIONS=("${MENU_OPTIONS[@]:1}" "${MENU_OPTIONS[0]}")

    # Передаёт в gum choose отсортированный для показа массив.
    CHOICE=$(gum choose "${DISPLAY_OPTIONS[@]}")

    case "$CHOICE" in
        "${MENU_OPTIONS[1]}") # Сохранить (git push)
            "$REPO_ROOT/tools/git-manager/push.sh"
            ;;

        "${MENU_OPTIONS[2]}") # Обновить (git pull)
            "$REPO_ROOT/tools/git-manager/pull.sh"
            ;;

        "${MENU_OPTIONS[3]}")  # Утилита для переименования
            "$REPO_ROOT/tools/renamer/run-for-wallpapers.sh"
            ;;

        "${MENU_OPTIONS[0]}")  # Выход
            break
            ;;
    esac

    # --- Меню после действия ---
    # Если был выбран не "Выход", показывает это меню
    if [[ "$CHOICE" != ${MENU_OPTIONS[0]} ]]; then
        gum confirm "Вернуться в главное меню?" && continue || break
    fi
done

# Прощальное сообщение
echo -e "${DECOR_BLUE} Работа завершена. Окно закроется через 3 секунды...${RESET}"
sleep 3
