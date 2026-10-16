#!/usr/bin/env bash
# =============================================================================
# /launcher/find_terminal.sh
# -----------------------------------------------------------------------------
# Поиск терминала по умолчанию для запуска скрипта в новом окне.
#
# Зависимости:
#   ./de.sh: detect_de, get_terminal_for_de
#   ./ui.sh: p_debug, p_error, f_bold, f_green
# =============================================================================


# =============================
# Сборка команды для запуска скрипта в новом окне терминала
# -----------------------------
# Заполняет массив (по имени, через nameref), ничего не запускает.
#
# Параметры:
#   $1 — имя массива, в который будет записана команда
#   $2 — путь к исполняемому файлу
#   $@ — аргументы для целевого скрипта
#
# Возвращает: 0 — команда собрана, 1 — ошибка
# =============================
build_terminal_cmd() {
  local -n _btc_out="$1"; shift
  local path_to_script="$1"; shift
  local terminal
  local term_name
  local flag

  if ! terminal="$(get_terminal)"; then
    p_error 'Не удалось найти поддерживаемый эмулятор терминала.'
    return 1
  fi

  term_name="${terminal##*/}"
  flag="$(get_term_flag "$term_name")"

  _btc_out=("$terminal")
  if [[ -n "$flag" ]]; then
    _btc_out+=("$flag")
  fi
  _btc_out+=("$path_to_script" "$@")
}


# =============================
# Главная функция поиска терминала
# -----------------------------
# Ищет терминал, подходящий для запуска основного скрипта в новом окне.
# -----------------------------
# Проверяет, поддерживается ли DE пользователя.
#   Если да: ищет терминал по умолчанию для DE.
#   Если нет: ищет в списке поддерживаемых терминалов.
#
# Возвращает: путь до бинарника терминала.
# =============================
get_terminal() {
  local de
  local terminal

  if \
    de="$(detect_de)" \
    && terminal="$(get_terminal_for_de "$de")" \
    && [[ -n "$terminal" ]]; then

    p_debug "Для $(f_bold "$de") используется терминал: $(f_bold "$terminal")"
    printf '%s' "$terminal"
    return 0
  fi

  p_debug 'Не удалось определить DE или терминал для него. Перебор списка по умолчанию...'

  # Если DE пользователя не поддерживается
  for terminal in "${DEFAULT_TERMINALS[@]}"; do
    if command -v "$terminal" &>/dev/null; then
      p_debug "Найден терминал из списка: $(f_bold "$terminal")"
      printf '%s' "$terminal"
      return 0
    fi
  done

  return 1
}


# =============================
# Адаптер флагов терминала
# -----------------------------
# Определяет корректный ключ запуска для переданного имени терминала.
# Используется для унификации запуска скриптов в разных эмуляторах.
#
# Параметры:
#   $1 — имя терминала (например, "konsole", "gnome-terminal")
#
# Возвращает (printf):
#   Строку с флагом ("-e", "-x", "--") или пустую строку,
#   если флаг не требуется (например, для kitty).
#   Если терминал неизвестен, возвращает стандартный флаг "-e".
# =============================
get_term_flag() {
  if [[ $# -ne 1 ]]; then
    p_error "$(f_bold 'get_term_flag') требует 1 аргумент — название терминала."
    return 1
  fi

  local term_name="$1"
  local flag

  case "$term_name" in
    gnome-terminal|tilix|ptyxis)
      flag='--'
      ;;
    terminator|xfce4-terminal|mate-terminal)
      flag='-x'
      ;;
    kitty|foot)
      flag=''
      ;;
    konsole|alacritty|xterm|urxvt|rxvt|st|kgx)
      flag='-e'
      ;;
    *)
      flag='-e'

      local message
      message="Неизвестный терминал $(f_bold "$term_name"). Используется стандартный флаг -e."
      message="$(f_yellow "$message")"
      p_debug "$message"
      ;;
  esac
  p_debug "get_term_flag: [$flag]"

  # Необходимо для корректной передачи флагов, которые echo может интерпретировать как опцию
  printf '%s' "$flag"
}
