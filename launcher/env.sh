#!/usr/bin/env bash
# shellcheck disable=SC2034
set -o errexit
set -o nounset
set -o pipefail

USE_COLOR=1

unset DEBUG
unset NO_WINDOW
unset USE_COLOR_SET_BY_CLI


# =============================
# Разбор аргументов командной строки
# -----------------------------
# Читает переданные скрипту ключи и переопределяет глобальные переменные конфигурации.
#
# Параметры:
#   $@ — все аргументы скрипта
# =============================
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -N|--no-color) USE_COLOR=0; USE_COLOR_SET_BY_CLI=1; shift ;;
      -W|--no-window) NO_WINDOW=1; shift ;;
      -d|--debug) DEBUG=1; shift ;;
      -h|--help|help) show_help; exit 0 ;;
      -v|--version) echo "v$VERSION"; exit 0 ;;
      -*)
        echo "Неизвестная опция: $1. Используйте --help для справки." >&2
        exit 1
        ;;
      *)
        echo "Ошибка: Скрипт не принимает позиционные аргументы ('$1')." >&2
        exit 1
        ;;
    esac
  done
}


# =============================
# Инициализация окружения
# -----------------------------
# - Настраивает форматирование выводимого текста
# - Устанавливает значения для важных переменных
# =============================
init_env() {
  _init_debug_env
  _init_terminal_list

  e_debug "Запуск инициализации окружения..."

  if ! command -v git >/dev/null 2>&1; then
    e_error "Не найден git. Установите его, чтобы использовать этот скрипт."
    exit 1
  fi

  # Хранит название конфигурации из .gitmodules для использования
  REPO_TOOLS_SUBMODULE_NAME="tools"
  REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
  e_debug "REPO_ROOT = $REPO_ROOT"
  TARGET_SCRIPT="${REPO_ROOT}/tools/start"
  DE=""
  TERMINAL_FOR_DE=""


  e_debug "Переменные окружения подготовлены."
  e_debug "Рабочая директория: $(f_bold "$SCRIPT_DIR")"
  e_debug "Целевой скрипт: $(f_bold "$TARGET_SCRIPT")"
}


# =============================
# Управляет поведением режима отладки
# -----------------------------
# Устанавливает поведение по умолчанию:
#   в режиме отладки принудительно выполнить запуск целевого скрипта в новом окне.
#
# Если запущен с ключами -W или --no-window, то принудительный запуск нового окна отменяется.
# =============================
_init_debug_env() {
  DEBUG_FORCE_WINDOW=1

  if [[ -v NO_WINDOW ]]; then
    DEBUG_FORCE_WINDOW=0
  fi
}


# =============================
# Список терминалов для проверки
# -----------------------------
# Инициализирует список терминалов, который используется в случае,
# если не удалось определить терминал по умолчанию в DE пользователя.
# =============================
_init_terminal_list() {
  DEFAULT_TERMINALS=(
    "konsole"        # Многофункциональный терминал для среды KDE
    "gnome-terminal" # Стандартный терминал для среды GNOME
    "gnome-console"  # Легковесный терминал для GNOME, замена gnome-terminal
    "xfce4-terminal" # Легковесный терминал, идущий в комплекте с XFCE
    "kitty"          # Быстрый, настраиваемый терминал с поддержкой GPU
    "alacritty"      # Легковесный, высокопроизводительный терминал с акцентом на простоту
    "xterm"          # Классический, минималистичный терминал для X Window System
  )
}
