#!/usr/bin/env bash

# Определяет корневую директорию репозитория и переходит в неё
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Подключает конфигурацию с декором, проверками и переменными
if [[ -d "$SCRIPT_DIR" ]]; then
    source "${SCRIPT_DIR}/config.sh"
else
    echo "Не удалось подключить config.sh" >&2
    exit 1
fi

# Подключает дополнительные инструменты
# TERMINAL: переменная, в которой записан путь до бинаркика первого найденного эмулятора терминала.
# confirm "str": Обёртка, которая запрашивает подтверждение выполняемых действий (по умолчанию "Y").
# refuse "str": Обёртка, аналогичная confirm, только со значением по умолчанию "N".
if [[ -d "$SCRIPT_DIR" ]]; then
    source "${SCRIPT_DIR}/utils.sh"
else
    echo "Не удалось подключить utils.sh" >&2
    exit 1
fi

# === Git === #

# Определяет корневую директорию репозитория и переходит в неё
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1


if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo -e "${DECOR_BLUE} ${FG_YELLOW}Нет изменений для коммита${RESET}"
else
    DATE_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
    echo -e "${DECOR_BLUE} Создание коммита..."
    git add .
    git commit -m "Auto: $DATE_TIME"
    echo -e "${DECOR_BLUE} ${FG_GREEN}Коммит создан${RESET}"
fi

git status

if confirm "Отправить изменения в репозиторий"; then
    echo -e "${DECOR_BLUE} Сохранение и отправка изменений..."
    if ! git push "$@"; then
        echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось выполнить push"
        echo -e "${FG_GREEN}Доступен ввод команд:${RESET} >>"
        exec bash
    fi
    echo -e "${DECOR_BLUE} ${FG_GREEN}Изменения отправлены${RESET}"
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Отмена${RESET}"
fi


# Завершение
echo -e "${DECOR_BLUE} ${DECOR_SUCCESS}"
echo -e "${BOLD}Нажмите любую клавишу для закрытия окна:${RESET}"
read -n 1 -s -r
