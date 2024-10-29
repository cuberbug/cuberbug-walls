#!/usr/bin/bash

# Хранит константы для оформления и работы с текстом


BOLD_DARK_RED="\e[1:31m"
BOLD_DARK_BLUE="\e[1;94m"
BOLD_GREEN="\e[1;92m"

D_GREEN="\e[92m"
D_ORANGE="\e[33m"
D_BOLD="\e[1m"
D_CANCEL="\e[0m"

BLUE_DECOR="${BOLD_DARK_BLUE}::${D_CANCEL}"
ERROR_DECOR="${BOLD_DARK_RED}Ошибка:${D_CANCEL}"
COMPLETE_DECOR="${BOLD_GREEN}Готово!${D_CANCEL}"
