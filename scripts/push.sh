#!/usr/bin/bash

# Определить корневую директорию репозитория
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Перейти в корневую директорию
cd "$REPO_ROOT" || exit 1

# Сохрить дату и время в удобном формате
DATE_TIME=$(date -u +"%Y-%m-%d %H:%M:%S")

# Вывести результат
echo -e "\e[1mТекущая дата и время (UTC):\e[0m $DATE_TIME"


## Взаимодействие с Git
echo -e "\e[1;94m::\e[0m Создание коммита"
git add .
git commit -m "Auto: $DATE_TIME"

echo -e "\e[1;94m::\e[0m Сохранение и отправка изменений"
git push


## Завершение
echo -e "\e[1;94m::\e[0m \e[1;92mГотово!\e[0m"
echo -e "\e[1mНажмите любую клавишу для закрытия окна:\e[0m"
read -n 1 -s -r
