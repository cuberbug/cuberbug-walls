#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/../git-manager/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1


# --- Работа с виртуальным окружением ---

VENV_PYTHON=""

if [[ -d "$REPO_ROOT/tools/renamer/.venv" ]]; then
    echo -e "${DECOR_BLUE} Найдено установленное виртуальное окружение Python."
    echo "Скрипт будет выполнен в виртуальном окружении."
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Виртуальное окружение Python не установлено.${RESET}"
    echo "Вы можете установить его автоматически в директорию инструмента или использовать системный интерпретатор."
    echo "Рекомендуется использовать виртуальное окружение, так как это безопасней и позволяет разрешить зависимости."
    if confirm "Создать виртуальное окружение Python в ./tools/renamer/.venv"; then

        echo -e "${DECOR_BLUE} Создание виртуального окружения..."
        cd ${REPO_ROOT}/tools/renamer
        python3 -m venv .venv
        VENV_PYTHON="${REPO_ROOT}/tools/renamer/.venv/bin/python"

        if [[ -f "${REPO_ROOT}/tools/renamer/requirements.txt" ]]; then
            echo -e "${DECOR_BLUE} Обновление пакетного менеджера и установка зависимостей..."
            source .venv/bin/activate
            python3 -m pip install --upgrade pip
            pip install -r requirements.txt
            deactivate
        else
            echo -e "${DECOR_BLUE} Установка зависимостей не требуется."
        fi

        echo -e "${DECOR_BLUE} ${FG_GREEN}Виртуальное окружение настроено готово к использованию.${RESET}"
    else
        echo -e "${DECOR_YELLOW} ${FG_YELLOW}Скрипт будет выполняться системным интерпретатором.${RESET}"
    fi
fi


# --- Запуск основной логики ---

if confirm "Выполнить переименование всех изображений в директории ./wallpapers"; then
    cd "${REPO_ROOT}/tools/renamer" || exit 1

    PYTHON_CMD="$(choose_python "${VENV_PYTHON}")"
    if ! "$PYTHON_CMD" main.py "${REPO_ROOT}/wallpapers"; then
        echo -e "${DECOR_ERROR} Не удалось выполнить переименование." >&2
        exit 1
    fi

    echo -e "${DECOR_BLUE} ${FG_GREEN}Переименование изображений завершено.${RESET}"
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Отмена выполнения переименования.${RESET}"
fi
