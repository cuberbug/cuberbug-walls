#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/../git-manager/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1

PATH_TO_RENAMER_DIR="${REPO_ROOT}/tools/renamer"
PATH_TO_REQUIREMENTS="${REPO_ROOT}/tools/renamer/requirements.txt"
PATH_TO_VENV_ACTIVATE="${PATH_TO_RENAMER_DIR}/.venv/bin/activate"
VENV_DIR="$REPO_ROOT/tools/renamer/.venv"
VENV_PYTHON=""


# --- Работа с виртуальным окружением ---

if [[ -d "$VENV_DIR" ]]; then
    echo -e "${DECOR_GREEN} Найдено установленное виртуальное окружение Python."
    VENV_PYTHON="${REPO_ROOT}/tools/renamer/.venv/bin/python"

    if [[ -f "${PATH_TO_REQUIREMENTS}" && -s "${PATH_TO_REQUIREMENTS}" ]]; then
        install_requirements --activate "${PATH_TO_VENV_ACTIVATE}" \
                             --python "${VENV_PYTHON}" \
                             --requirements "${PATH_TO_REQUIREMENTS}"
    else
        echo -e "${DECOR_GREEN} Обновление зависимостей не требуется."
    fi

    echo -e "${DECOR_GREEN} Скрипт будет выполнен в виртуальном окружении."
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Виртуальное окружение Python не установлено.${RESET}"
    echo "Вы можете установить его автоматически в директорию инструмента или использовать системный интерпретатор."
    echo "Рекомендуется использовать виртуальное окружение, так как это безопасней и позволяет разрешить зависимости."

    if confirm "Создать виртуальное окружение Python в ./tools/renamer/.venv"; then
        echo -e "${DECOR_BLUE} Создание виртуального окружения..."
        cd ${PATH_TO_RENAMER_DIR}
        python3 -m venv .venv
        VENV_PYTHON="${REPO_ROOT}/tools/renamer/.venv/bin/python"

        if [[ -f "${PATH_TO_REQUIREMENTS}" && -s "${PATH_TO_REQUIREMENTS}" ]]; then
            install_requirements --activate "${PATH_TO_VENV_ACTIVATE}" \
                                 --python "${VENV_PYTHON}" \
                                 --requirements "${PATH_TO_REQUIREMENTS}"
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
    cd "${PATH_TO_RENAMER_DIR}" || exit 1

    PYTHON_CMD="$(choose_python "${VENV_PYTHON}")"
    if ! "$PYTHON_CMD" main.py "${REPO_ROOT}/wallpapers"; then
        echo -e "${DECOR_ERROR} Не удалось выполнить переименование." >&2
        exit 1
    fi

    echo -e "${DECOR_BLUE} ${FG_GREEN}Переименование изображений завершено.${RESET}"
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Отмена выполнения переименования.${RESET}"
fi
