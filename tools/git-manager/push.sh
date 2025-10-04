#!/usr/bin/env bash

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/../shared/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1


# --- Git ---

git status


if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo -e "${DECOR_BLUE} ${FG_YELLOW}Нет изменений для коммита${RESET}"
else
    if confirm "Составить автоматический коммит"; then
        DATE_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
        echo -e "${DECOR_BLUE} Создание коммита..."
        git add .
        git commit -m "Auto: $DATE_TIME"
        echo -e "${DECOR_BLUE} ${FG_GREEN}Коммит создан${RESET}"
    else
        echo -e "${DECOR_YELLOW} ${FG_YELLOW}Отмена${RESET}"
    fi
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
