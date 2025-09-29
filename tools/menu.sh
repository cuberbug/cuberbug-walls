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


# --- Главный цикл меню ---

while true; do
    clear
    
    # Использует 'gum choose' для создания интерактивного меню
    # --height 10 задаёт высоту окна меню
    CHOICE=$(gum choose --height 10 \
        "Сохранить (git push)" \
        "Обновить (git pull)" \
        "Утилита для переименования" \
        "Выход")

    # Обрабатываем выбор пользователя
    case "$CHOICE" in
        "Сохранить (git push)")
            "$REPO_ROOT/tools/git-manager/push.sh"
            ;;

        "Обновить (git pull)")
            "$REPO_ROOT/tools/git-manager/pull.sh"
            ;;

        "Утилита для переименования")
            echo -e "${DECOR_YELLOW} Эта функция пока в разработке...${RESET}"
            ;;

        "Выход")
            break
            ;;
    esac

    # --- Меню после действия ---
    # Если был выбран не "Выход", показываем это меню
    if [[ "$CHOICE" != "Выход" ]]; then
        gum confirm "Вернуться в главное меню?" && continue || break
    fi
done

# Прощальное сообщение
echo -e "${DECOR_BLUE} Работа завершена. Окно закроется через 3 секунды...${RESET}"
sleep 3
