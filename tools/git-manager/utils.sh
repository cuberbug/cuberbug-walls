#!/usr/bin/env bash

# Запрашивает подтверждение выполнения действий, обёрнутых этой функцией.
# Принимает строку, которая является запросом на подтверждение.
confirm() {
    local message=$1
    while true; do
        read -p "$(echo -e "\n${DECOR_BLUE} ${BOLD}${message}?${RESET} [Y/n]: ")" response
        case "$response" in
            [Yy]* | "") return 0 ;;
            [Nn]* ) return 1 ;;
            * ) echo -e "${DECOR_BLUE} ${FG_YELLOW}Неверный ввод, попробуйте снова.${RESET}" ;;
        esac
    done
}

# Запрашивает подтверждение на выполнение действия, как и confirm,
# но по умолчанию установлен вариант "N", то есть отказ.
refuse() {
    local message=$1
    while true; do
        read -p "$(echo -e "\n${DECOR_BLUE} ${BOLD}${message}?${RESET} [y/N]: ")" response
        case "$response" in
            [Yy]* ) return 0 ;;
            [Nn]* | "") return 1 ;;
            * ) echo -e "${DECOR_BLUE} ${FG_YELLOW}Неверный ввод, попробуйте снова.${RESET}" ;;
        esac
    done
}

# Проверяет полученное значение на то, является ли оно ссылкой на интерпретатор.
# Если нет, то возвращает системный интерпретатор python.
choose_python() {
    local python_cmd=$1
    if [[ -n "$python_cmd" && -f "$python_cmd" ]]; then
        echo "$python_cmd"
    else
        command -v python3 || command -v python
    fi
}
