#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/git-manager/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1

# Проверяет, что gum установлен
if ! command -v gum &>/dev/null; then
    echo -e "${DECOR_ERROR} Gum не установлен. Этот пакет является обязательной зависимостью для меню." >&2
    exit 1
fi


# --- Настройки меню ---

MENU_OPTIONS=(
    "Сохранить (git push)"
    "Обновить (git pull)"
    "Утилита для переименования"
    "Выход"
)


# --- Главный цикл меню ---

while true; do
    clear
    
    # Использует 'gum choose' для создания интерактивного меню
    CHOICE=$(gum choose "${MENU_OPTIONS[@]}")

    case "$CHOICE" in
        "${MENU_OPTIONS[0]}") # Сохранить (git push)
            "$REPO_ROOT/tools/git-manager/push.sh"
            ;;

        "${MENU_OPTIONS[1]}") # Обновить (git pull)
            "$REPO_ROOT/tools/git-manager/pull.sh"
            ;;

        "${MENU_OPTIONS[2]}")  # Утилита для переименования
            echo -e "${DECOR_YELLOW} Эта функция пока в разработке...${RESET}"
            ;;

        "${MENU_OPTIONS[3]}")  # Выход
            break
            ;;
    esac

    # --- Меню после действия ---
    # Если был выбран не "Выход", показывает это меню
    if [[ "$CHOICE" != "Выход" ]]; then
        gum confirm "Вернуться в главное меню?" && continue || break
    fi
done

# Прощальное сообщение
echo -e "${DECOR_BLUE} Работа завершена. Окно закроется через 3 секунды...${RESET}"
sleep 3
