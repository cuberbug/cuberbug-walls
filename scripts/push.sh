#!/usr/bin/bash

# Определяет корневую директорию репозитория
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Перейти в корневую директорию
cd "$REPO_ROOT" || exit 1


## Взаимодействие с Git
if git diff --quiet && git diff --cached --quiet; then
    echo -e "\e[1;94m::\e[0m \e[33mНет изменений для коммита.\e[0m"
else
    DATE_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")
    echo -e "\e[1;94m::\e[0m Создание коммита"
    git add .
    git commit -m "Auto: $DATE_TIME"
fi

echo -e "\e[1;94m::\e[0m Сохранение и отправка изменений"
if ! git push "$@"; then
    echo -e "\e[31mОшибка:\e[0m Не удалось выполнить push."
    exec bash
fi


## Завершение
echo -e "\e[1;94m::\e[0m \e[1;92mГотово!\e[0m"
echo -e "\e[1mНажмите любую клавишу для закрытия окна:\e[0m"
read -n 1 -s -r
