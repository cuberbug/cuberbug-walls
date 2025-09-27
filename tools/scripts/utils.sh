#!/usr/bin/env bash

# Запрашивает подтверждение выполнения действий, обёрнутых этой функцией.
# Принимает строку, которая является запросом на подтверждение.
confirm() {
    local message=$1
    echo -en "${DECOR_BLUE} ${BOLD}${message}?${RESET} [Y/n]: "
    read -r response
    case "$response" in
        [Yy]* | "") return 0 ;;  # По умолчанию — "да"
        [Nn]* ) return 1 ;;      # "Нет" — не выполнять
        *)
            echo -e "${DECOR_BLUE} ${FG_YELLOW}Неверный ввод, попробуйте снова.${RESET}"
            confirm "$message"   # Рекурсия до правильного ввода
        ;;
    esac
}

# Запрашивает подтверждение на выполнение действия, как и confirm,
# но по умолчанию установлен вариант "N", то есть отказ.
refuse() {
    local message=$1
    echo -en "${DECOR_YELLOW} ${FG_YELLOW}${message}?${RESET} [y/N]: "
    read -r response
    case "$response" in
        [Yy]* ) return 0 ;;
        [Nn]* | "") return 1 ;;  # "Нет" — не выполнять (по умолчанию)
        *)
            echo -e "${DECOR_BLUE} ${FG_YELLOW}Неверный ввод, попробуйте снова.${RESET}"
            refuse "$message"    # Рекурсия до правильного ввода
        ;;
    esac
}
