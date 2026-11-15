#!/usr/bin/env bash
# =============================================================================
# /src/launcher/ui.sh
# -----------------------------------------------------------------------------
# Функции для вывода текста в терминал с форматированием.
#
# Зависимости:
#   ./env.sh: is_no_color, is_debug, LAUNCHER_NO_COLOR, LAUNCHER_DEBUG
# =============================================================================


readonly LAUNCHER_VERSION='1.3.11'

BOLD='' NO_BOLD=''
RED='' GREEN='' YELLOW='' BLUE=''
CANCEL_COLOR=''


# =============================
# Многострочный вывод текста в терминал
# -----------------------------
# Содержит функции с выводом:
#   - справочной информации о скрипте
#   - приветственного сообщения в начале работы
# =============================

show_help() {
  cat <<EOF
Submodule Launcher — устанавливает сабмодуль и запускает находящиеся в нём утилиты.
Версия: $LAUNCHER_VERSION

Описание:
  Скрипт проверяет и обновляет сабмодуль 'tools' до указанной ветки,
  после чего запускает основной сценарий (./tools/start).
  Запуск происходит в текущем терминале или в новом окне, в зависимости от контекста.

  В случае использования отладки (-d, --debug) или --no-color,
  эти параметры будут переданы в целевой скрипт.

Использование:
  ${0##*/} [опции]

Опции:
  -b, --branch NAME   Установить конкретную ветку для сабмодуля tools
                      (по умолчанию: main)
  -d, --debug         Запуск в режиме отладки (вывод подробных логов)
  -W, --no-window     Отменяет принудительный запуск нового окна терминала
                      (актуально только для режима отладки)
  -N, --no-color      Отключает цветной вывод в терминал
                      (также поддерживается переменная окружения NO_COLOR)
  -h, --help          Показать эту справку
  -v, --version       Показать версию скрипта

Примеры:
  ./${0##*/}
      Стандартный запуск (ветка main).

  ./${0##*/} --branch dev
      Запуск с переключением инструментов на ветку dev
      (полезно для тестирования новых функций).

EOF
}

show_hello() {
  cat <<EOF
========= cuberbug-walls: Submodule Launcher / v$LAUNCHER_VERSION
EOF
}


# =============================
# Определяет переменные и поведение для оформления вывода текста
# -----------------------------
# Заполняет переменные с escape-последовательностями. Форматирование
# отключается, если задана переменная окружения NO_COLOR, передан флаг
# --no-color, stderr не является терминалом или TERM=dumb.
#
# Если форматирование отключено из-за NO_COLOR, устанавливает
# LAUNCHER_NO_COLOR=1, чтобы флаг был передан в целевой скрипт.
# В режиме отладки сообщает причину отключения.
#
# Зависимости:
#   ./env.sh: is_debug, is_no_color, LAUNCHER_NO_COLOR
#
# Порядок вызова:
#   После parse_args (нужны LAUNCHER_DEBUG и флаг --no-color)
#   и до init_target_args (читает LAUNCHER_NO_COLOR).
# =============================
init_format() {
  local reason=''

  if [[ -n "${NO_COLOR:-}" ]]; then
    # shellcheck disable=SC2034  # читается в ./env.sh: is_no_color
    LAUNCHER_NO_COLOR=1
    reason="задана переменная окружения NO_COLOR=$NO_COLOR "
    reason+="(LAUNCHER_NO_COLOR=$LAUNCHER_NO_COLOR, "
    reason+='флаг --no-color будет передан дальше)'
  elif is_no_color; then
    reason='передан флаг --no-color'
  elif [[ ! -t 2 ]]; then
    reason='stderr не является терминалом'
  elif [[ "${TERM:-}" == 'dumb' ]]; then
    reason='TERM=dumb'
  fi

  if [[ -n "$reason" ]]; then
    p_debug "Форматирование вывода отключено: $reason."
    return 0
  fi

  BOLD=$'\033[1m'
  NO_BOLD=$'\033[22m'
  RED=$'\033[31m'
  GREEN=$'\033[32m'
  YELLOW=$'\033[33m'
  BLUE=$'\033[34m'
  CANCEL_COLOR=$'\033[39m'
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
#   - p_info:   о происходящих событиях
#   - p_done:   об успешном выполнении действия
#   - p_error:  об ошибке
#   - p_debug:  информация для отладки
#
# Пример использования:
#   p_info "Вывод $(f_red "красного") и $(f_green "зелёного") текста"
# =============================

f_bold()   { _format "$BOLD"   "$NO_BOLD"      "$@"; }
f_red()    { _format "$RED"    "$CANCEL_COLOR" "$@"; }
f_green()  { _format "$GREEN"  "$CANCEL_COLOR" "$@"; }
f_yellow() { _format "$YELLOW" "$CANCEL_COLOR" "$@"; }
f_blue()   { _format "$BLUE"   "$CANCEL_COLOR" "$@"; }

_format() {
  local start_code="$1"
  local end_code="$2"
  shift 2

  printf '%s%s%s' "$start_code" "$*" "$end_code"
}

p_info() {
  local icon='●'

  icon="${BLUE}${BOLD}$icon${NO_BOLD}${CANCEL_COLOR}"
  printf ' %s %s\n' "$icon" "$*" >&2
}

p_done() {
  local icon='✔'

  icon="${GREEN}${BOLD}$icon${NO_BOLD}${CANCEL_COLOR}"
  printf ' %s %s\n' "$icon" "$*" >&2
}

p_error() {
  local icon='[ ERROR ]'

  icon="${RED}${BOLD}$icon${NO_BOLD}${CANCEL_COLOR}"
  printf '%s %s\n' "$icon" "$*" >&2
}

p_debug() {
  if ! is_debug; then
    return 0
  fi

  local icon='[ DEBUG ]'

  icon="${YELLOW}${BOLD}$icon${NO_BOLD}${CANCEL_COLOR}"
  printf '%s %s\n' "$icon" "$*" >&2
}
