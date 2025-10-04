#!/usr/bin/env bash

# Подключает общую логику, переменные и проверки
source "$(dirname "${BASH_SOURCE[0]}")/../shared/common.sh" || exit 1
cd "$REPO_ROOT" || exit 1


# --- Git ---

git fetch --quiet

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u} 2>/dev/null)

if [[ "$LOCAL" == "$REMOTE" ]]; then
    echo -e "${DECOR_BLUE} ${FG_GREEN}Репозиторий уже находится в актуальном состоянии.${RESET}"
    exit 0
fi

git status

if confirm "Обновить локальный репозиторий"; then
    echo -e "${DECOR_BLUE} Загрузка актуального состояния репозитория..."
    if ! git pull "$@"; then
        echo -e "${DECOR_BLUE} ${DECOR_ERROR} Не удалось выполнить pull"
        exit 1
    fi
    echo -e "${DECOR_BLUE} ${FG_GREEN}Локальный репозиторий обновлён${RESET}"
else
    echo -e "${DECOR_YELLOW} ${FG_YELLOW}Отмена${RESET}"
fi
