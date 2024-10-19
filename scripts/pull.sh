#!/usr/bin/bash

# Определяет корневую директорию репозитория
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Перейти в корневую директорию
cd "$REPO_ROOT" || exit 1


## Взаимодействие с Git
echo -e "\e[1;94m::\e[0m Загрузка актуального состояния репозитория."
if ! git pull "$@"; then
    echo -e "\e[31mОшибка:\e[0m Не удалось выполнить pull."
    exit 1
fi


## Завершение
echo -e "\e[1;94m::\e[0m \e[1;92mГотово!\e[0m"
echo -e "\e[1mНажмите любую клавишу для закрытия окна:\e[0m"
read -n 1 -s -r
