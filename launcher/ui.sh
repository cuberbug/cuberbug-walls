#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

VERSION="1.3.1"


# =============================
# Многострочный вывод текста в терминал
# -----------------------------
# Содержит функции с выводом:
#   - справочной информации о скрипте
#   - приветственного сообщения в начале работы
# =============================

show_help() {
  cat <<EOF
Tool Launcher — универсальный менеджер установки и запуска утилит.
Версия: $VERSION

Описание:
  Скрипт обновляет сабмодуль 'tools' и запускает основной сценарий (./tools/start)
  либо в текущем терминале, либо в новом окне терминала в зависимости от контекста.


Использование:
  $(basename "$0") [опции]


Опции:
  -h, --help, help  Показать эту справку
  -v, --version     Показать версию скрипта
  -d, --debug       Запуск в режиме отладки
  -W, --no-window   Отменяет принудительный запуск нового окна терминала в режиме отладки
  -N, --no-color    Отключает цветной вывод в терминал
                    Также поддерживается переменная окружения 'NO_COLOR'

Примеры:
  ./$(basename "$0")
      Запускает основной скрипт в текущем терминале или открывает новое окно,
      если запущен вне терминала.

EOF
}

show_hello() {
  cat <<EOF
  :::::::::::::::::::
 ::: Tool Launcher :::
:::::::::::::::: v$VERSION

EOF
}


# =============================
# Определяет переменные и поведение для оформления вывода текста
# -----------------------------
# Содержит переменные с escape-последовательностями.
#
# Если в переменных окружения пользователя задано NO_COLOR или скрипт запущен
# с ключами -N или --no-color, то отключает использование цветного вывода.
# -----------------------------
init_format() {
  BOLD="\e[1m"
  NO_BOLD="\e[22m"

  # Применяет NO_COLOR только если не было ключа
  if [[ -z "${USE_COLOR_SET_BY_CLI:-0}" && -v NO_COLOR ]]; then
    USE_COLOR=0
  fi

  if [[ "$USE_COLOR" -eq 1 ]]; then
    RED="\e[31m"
    GREEN="\e[32m"
    YELLOW="\e[33m"
    BLUE="\e[34m"
    CANCEL_COLOR="\e[39m"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    CANCEL_COLOR=""
  fi
}


# =============================
# Форматирование текста
# -----------------------------
# Содержит набор простых функций для оформления выводимого текста:
#   - f_bold:   жирный
#   - f_red:    красный
#   - f_green:  зелёный
#   - f_yellow: жёлтый
#   - f_blue:   синий
#
# Функции для вывода стилизованных информационных сообщений:
#   - e_info:   о происходящих событиях
#   - e_done:   об успешном выполнении действия
#   - e_error:  об ошибке
#   - e_debug:  информация для отладки
#
# Пример использования:
#   e_info "Вывод $(f_red "красного") и $(f_green "зелёного") текста"
# =============================

f_bold()   { _format "$BOLD"   "$NO_BOLD"      "$@"; }
f_red()    { _format "$RED"    "$CANCEL_COLOR" "$@"; }
f_green()  { _format "$GREEN"  "$CANCEL_COLOR" "$@"; }
f_yellow() { _format "$YELLOW" "$CANCEL_COLOR" "$@"; }
f_blue()   { _format "$BLUE"   "$CANCEL_COLOR" "$@"; }

e_info() {
  local message=("$@")
  local icon="●"

  icon=$(f_bold "$icon")
  icon=$(f_blue "$icon")
  printf " %s %s\n" "${icon}" "${message[*]}" >&2
}

e_done() {
  local message=("$@")
  local icon="✔"

  icon=$(f_bold "$icon")
  icon=$(f_green "$icon")
  printf " %s %s\n" "${icon}" "${message[*]}" >&2
}

e_error() {
  local message=("$@")
  local icon="ERROR"

  icon=$(f_bold "$icon")
  icon=$(f_red "$icon")
  printf "[ %s ] %s\n" "$icon" "${message[*]}" >&2
}

e_debug() {
  local message=("$@")
  local icon="DEBUG"

  if [[ -v DEBUG ]]; then
    icon=$(f_yellow "$icon")
    printf "[ %s ] %s\n" "$icon" "${message[*]}" >&2
  fi
}

_format() {
  local start_code=$1
  local end_code=$2
  shift 2

  printf "%b%s%b" "$start_code" "$*" "$end_code"
}
