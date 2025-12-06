#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail


# =============================
# Запуск скрипта в новом окне терминала
# -----------------------------
# Запускает указанный исполняемый файл в новом окне терминала.
#
# Параметры:
#   $1 — путь к исполняемому файлу (обязательно)
#
# Определяет терминал по умолчанию через get_terminal()
# и подбирает корректный ключ запуска (-e, -x или --),
# так как разные эмуляторы терминала используют разные варианты.
#
# Возвращает:
#   0 — успешный запуск
#   1 — ошибка аргументов или отсутствующий файл
# =============================
run_in_terminal() {
  if [[ $# -ne 1 ]]; then
    e_error "$(f_bold "run_in_terminal") требует 1 аргумент — путь до скрипта."
    return 1
  fi

  local path_to_script=$1
  local terminal
  local term_name
  local flag
  local args=()

  if [[ ! -f "$path_to_script" ]]; then
    e_error "Файл $(f_bold "$path_to_script") не существует."
    return 1
  fi

  terminal=$(get_terminal)
  if [[ -z "$terminal" ]]; then
    e_error "Не удалось найти поддерживаемый эмулятор терминала."
    exit 1
  fi

  # Извлекаем чистое имя (например, /usr/bin/konsole -> konsole)
  term_name="${terminal##*/}"
  flag=$(get_term_flag "$term_name")

  # Формируем массив аргументов
  if [[ -n "$flag" ]]; then
    args=("$flag" "$path_to_script")
  else
    args=("$path_to_script")
  fi

  e_done "Запуск $(f_bold "$path_to_script") в новом окне ($(f_bold "$term_name"))..."
  e_debug "Выполняется команда: $(f_bold "$terminal ${args[*]}")"

  "$terminal" "${args[@]}"
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

  if de=$(detect_de); then
    terminal=$(get_terminal_for_de "$de")

    if [[ -n "$terminal" ]]; then
      e_debug "Для $(f_bold "$de") используется терминал: $(f_bold "$terminal")"
      echo "$terminal"
      return 0
    fi
  fi

  e_debug "Не удалось определить DE или терминал для него. Перебор списка по умолчанию..."

  # Если DE пользователя не поддерживается
  for terminal in "${DEFAULT_TERMINALS[@]}"; do
    if command -v "$terminal" &>/dev/null; then
      e_debug "Найден терминал из списка: $(f_bold "$terminal")"
      echo "$terminal"
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
    e_error "$(f_bold "get_term_flag") требует 1 аргумент — название терминала."
    return 1
  fi

  local term_name="$1"
  local flag

  case "$term_name" in
    gnome-terminal|gnome-console|tilix)
      flag="--"
      ;;
    terminator|xfce4-terminal)
      flag="-x"
      ;;
    kitty)
      flag=""
      ;;
    mate-terminal)
      flag="-e"
      ;;
    konsole|alacritty|xterm|urxvt|rxvt|st)
      flag="-e"
      ;;
    *)
      e_debug "$(f_yellow "Неизвестный терминал $(f_bold "$term_name")," \
              "используется стандартный флаг -e")"
      flag="-e"
      ;;
  esac

  # Необходимо для корректной передачи флагов, которые echo может интерпретировать как опцию
  printf "%s" "$flag"
}
