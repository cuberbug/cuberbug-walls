#!/usr/bin/bash

# Определение текущей директории
CURRENT_DIR=$(pwd)

# Попытка найти эмулятор терминала
TERMINAL="${TERMINAL:-$(command -v alacritty || command -v konsole || command -v gnome-terminal || command -v xterm)}"

# Проверка, найден ли эмулятор
if [ -z "$TERMINAL" ]; then
    echo -e "\e[1;94m::\e[0m \e[31mОшибка:\e[0m Не удалось найти эмулятор терминала."
    exit 1
fi

# Выводим найденный терминал
echo -e "\e[1;94m::\e[0m \e[1mДля запуска используется терминал:\e[0m $TERMINAL"
$TERMINAL -e "$CURRENT_DIR/scripts/push.sh"
