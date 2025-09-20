#!/usr/bin/bash

# Хранит константы для оформления и работы с текстом


D_GREEN="\e[32m"
D_ORANGE="\e[33m"
D_BOLD="\e[1m"
D_CANCEL="\e[0m"

BOLD_RED="\e[1;31m"
BOLD_BLUE="\e[1;34m"
BOLD_GREEN="\e[1;32m"


BLUE_DECOR="${BOLD_BLUE}::${D_CANCEL}"
ERROR_DECOR="${BOLD_RED}Ошибка:${D_CANCEL}"
COMPLETE_DECOR="${BOLD_GREEN}Готово! ${D_CANCEL}"
