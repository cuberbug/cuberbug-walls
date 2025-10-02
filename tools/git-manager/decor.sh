#!/usr/bin/env bash
# Хранит константы для оформления и работы с текстом


# Сброс форматирования
RESET="\e[0m"

# Стили
BOLD="\e[1m"
UNDERLINE="\e[4m"

# Цвета текста
FG_RED="\e[31m"
FG_GREEN="\e[32m"
FG_YELLOW="\e[33m"
FG_BLUE="\e[34m"

# Комбинированные стили
FG_BOLD_RED="\e[1;31m"
FG_BOLD_GREEN="\e[1;32m"
FG_BOLD_YELLOW="\e[1;33m"
FG_BOLD_BLUE="\e[1;34m"

# Декораторы (готовые конструкции для сообщений)
DECOR_RED="${FG_BOLD_RED}::${RESET}"
DECOR_GREEN="${FG_BOLD_GREEN}::${RESET}"
DECOR_YELLOW="${FG_BOLD_YELLOW}::${RESET}"
DECOR_BLUE="${FG_BOLD_BLUE}::${RESET}"
DECOR_ERROR="${FG_BOLD_RED}Ошибка:${RESET}"
DECOR_SUCCESS="${FG_BOLD_GREEN}SUCCESS${RESET}"
