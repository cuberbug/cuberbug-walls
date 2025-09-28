#!/usr/bin/env bash

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1


# --- Git ---

if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo -e "${DECOR_BLUE} ${FG_YELLOW}Нет изменений для коммита${RESET}"
else
    DATE_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
    echo -e "${DECOR_BLUE} Создание коммита..."
    git add .
    git commit -m "Auto: $DATE_TIME"
    echo -e "${DECOR_BLUE} ${FG_GREEN}Коммит создан${RESET}"
fi


if confirm "Отправить изменения в репозиторий"; then
    echo -e "${DECOR_BLUE} Сохранение и отправка изменений..."
    if ! git push "$@"; then
        echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось выполнить push."
        echo -e "${DECOR_YELLOW}Возможная причина: удалённый репозиторий был обновлён. \
                 Попробуйте сначала выполнить pull.${RESET}"
        exit 1
    fi
    echo -e "${DECOR_BLUE} ${FG_GREEN}Изменения отправлены${RESET}"
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Отмена${RESET}"
fi


# --- Завершение ---

echo -e "${BOLD}Нажмите любую клавишу для закрытия окна:${RESET}"
read -n 1 -s -r
