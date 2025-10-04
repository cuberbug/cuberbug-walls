#!/usr/bin/env bash

# Универсальная функция подтверждения.
# Принимает 2 аргумента:
# $1: Сообщение (обязательно).
# $2: Поведение по умолчанию (необязательно). Если передано "-n",
#     то стандартным ответом будет "нет". В остальных случаях - "да".
confirm() {
    local message=$1
    local default_choice=${2:-yes}
    local prompt_suffix

    if [[ "$default_choice" == "-n" ]]; then
        prompt_suffix="[y/N]"
    else
        prompt_suffix="[Y/n]"
    fi

    while true; do
        read -p "$(echo -e "\n${DECOR_BLUE} ${BOLD}${message}?${RESET} ${prompt_suffix}: ")" response

        if [[ "$default_choice" == "-n" ]]; then
            case "$response" in
                [Yy]*) return 0 ;;
                [Nn]* | "") return 1 ;;
                *) echo -e "${DECOR_BLUE} ${FG_YELLOW}Неверный ввод, попробуйте снова.${RESET}" ;;
            esac

        else
            case "$response" in
                [Yy]* | "") return 0 ;;
                [Nn]*) return 1 ;;
                *) echo -e "${DECOR_BLUE} ${FG_YELLOW}Неверный ввод, попробуйте снова.${RESET}" ;;
            esac
        fi
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

# Получает ссылки на файлы виртуального окружения и устанавливает зависимости
# --python: путь до интерпретатора
# --pip: путь до интерпретатора
# --requirements: путь до файла с зависимостями
install_requirements() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --python) python=$2; shift 2 ;;
            --pip) pip=$2; shift 2 ;;
            --requirements) requirements=$2; shift 2 ;;
            *) echo "Неизвестный аргумент: $1"; return 1 ;;
        esac
    done

    if [[ ! -f "$requirements" || ! -s "$requirements" ]]; then
        echo -e "${DECOR_GREEN} Установка зависимостей не требуется."
        return 0
    fi

    echo -e "${DECOR_BLUE} Обновление пакетного менеджера и установка зависимостей..."
    ${python} -m pip install --upgrade pip
    ${pip} install -r ${requirements}
    echo -e "${DECOR_BLUE} ${FG_GREEN}Виртуальное окружение настроено готово к использованию.${RESET}"
}
