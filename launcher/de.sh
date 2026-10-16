#!/usr/bin/env bash
# =============================================================================
# /launcher/de.sh
# -----------------------------------------------------------------------------
# Определение DE пользователя и поиск терминала по умолчанию
#
# Зависимости:
#   ./ui.sh: p_debug, p_error, f_bold, f_green
# =============================================================================


# =============================
# Глобальные переменные и массивы для работы с DE
# -----------------------------
#   DE_ORDER         — названия DE в порядке проверки. Если признаки совпали
#                      у нескольких DE, выбирается стоящее раньше.
#   DETECTORS        — название DE -> имя функции-проверки (is_*).
#   TERMINAL_GETTERS — название DE -> имя функции поиска терминала
#                      (get_*_default_terminal).
#
# Названия DE во всех трёх структурах должны совпадать символ в символ.
#
# При добавлении нового DE необходимо:
#   1. Добавить его название в массив DE_ORDER.
#   2. Написать функцию-проверку и добавить её имя в DETECTORS.
#   3. Написать функцию поиска терминала и добавить её имя
#      в TERMINAL_GETTERS.
# =============================
declare -ga DE_ORDER=('KDE Plasma' 'GNOME' 'XFCE')
declare -gA DETECTORS=(
  ['KDE Plasma']=is_kde
  ['GNOME']=is_gnome
  ['XFCE']=is_xfce
)
declare -gA TERMINAL_GETTERS=(
  ['KDE Plasma']=get_kde_default_terminal
  ['GNOME']=get_gnome_default_terminal
  ['XFCE']=get_xfce_default_terminal
)


# =============================
# Проверка доступности команды
# -----------------------------
# Проверяет, можно ли запустить команду, и определяет её полный путь.
# Использует command -v, поэтому для внешних программ возвращает путь
# из PATH, а для встроенных команд и функций — просто имя.
#
# Параметры:
#   $1 — имя команды или путь. Пустое значение считается неудачей.
#
# Возвращает (stdout):
#   Результат command -v; при неудаче ничего не выводит.
#
# Код возврата:
#   0 — команда найдена.
#   1 — команда не найдена или имя пустое.
# =============================
_print_executable() {
  local candidate="${1:-}"
  local resolved

  [[ -n "$candidate" ]] || return 1
  resolved="$(command -v -- "$candidate")" || return 1
  printf '%s' "$resolved"
}


# =============================
# Определение текущего графического окружения (DE)
# -----------------------------
# Перебирает DE в порядке DE_ORDER и вызывает для каждого функцию-проверку
# из DETECTORS. Первое сработавшее окружение считается текущим.
# DE, для которого в DETECTORS нет функции, пропускается.
#
# Зависимости:
#   DE_ORDER  — порядок проверки окружений
#   DETECTORS — название DE -> имя функции-проверки
#
# Возвращает (stdout):
#   Название найденного DE, например "KDE Plasma".
#
# Код возврата:
#   0 — окружение определено.
#   1 — ни один из детекторов не сработал (или DE_ORDER пуст).
# =============================
detect_de() {
  local de
  local detector

  for de in "${DE_ORDER[@]}"; do
    detector="${DETECTORS["$de"]:-}"

    if [[ -z "$detector" ]]; then
      p_debug "Для $(f_bold "$de") не задана функция-проверка, пропуск."
      continue
    fi

    if "${detector}"; then
      printf '%s' "$de"
      return 0
    fi
  done

  return 1
}


# =============================
# Поиск терминала по умолчанию для DE пользователя
# -----------------------------
# Находит в TERMINAL_GETTERS функцию для указанного DE и вызывает её.
#
# Параметры:
#   $1 — название DE (обязательно), ключ из DE_ORDER.
#        Например: "KDE Plasma".
#
# Зависимости:
#   TERMINAL_GETTERS — название DE -> имя функции поиска терминала
#
# Возвращает (stdout):
#   Путь до терминала, например "/usr/bin/konsole".
#
# Код возврата:
#   0 — терминал найден.
#   1 — ошибка аргументов, для DE нет функции поиска или терминал
#       не найден. Сообщение об ошибке выводится только при неверных
#       аргументах, в остальных случаях причину видно в режиме отладки.
# =============================
get_terminal_for_de() {
  if [[ $# -ne 1 ]]; then
    p_error "$(f_bold 'get_terminal_for_de') требует 1 аргумент — название DE."
    return 1
  fi

  local de="$1"
  local getter_func="${TERMINAL_GETTERS["$de"]:-}"
  local term_path

  if [[ -z "$getter_func" ]]; then
    p_debug "Для окружения $(f_bold "$de") нет определенной функции поиска терминала."
    return 1
  fi

  if term_path=$("$getter_func") && [[ -n "$term_path" ]]; then
    printf '%s' "$term_path"
    return 0
  fi

  p_debug "Не удалось определить терминал для $(f_bold "$de")."
  return 1
}


# =============================
# Функции определения DE
# -----------------------------
# Каждая функция проверяет, запущен ли сеанс соответствующего DE.
# Достаточно совпадения любого из признаков:
#   - XDG_CURRENT_DESKTOP (может содержать список через ':')
#   - DESKTOP_SESSION (для KDE также KDE_FULL_SESSION)
#   - запущенный процесс оболочки DE (проверка через pgrep)
# При обнаружении пишут сообщение в режиме отладки.
#
# Поддерживаются:
#   - KDE Plasma
#   - GNOME
#   - XFCE
#
# Код возврата:
#   0 — DE обнаружено.
#   1 — признаков DE не найдено.
# =============================

is_kde() {
  if [[ "${XDG_CURRENT_DESKTOP:-}" == *'KDE'* ]] \
    || [[ "${DESKTOP_SESSION:-}" == 'plasma' ]] \
    || [[ "${KDE_FULL_SESSION:-}" == 'true' ]] \
    || pgrep -x 'plasmashell' >/dev/null 2>&1; then

    p_debug "Обнаружено окружение: $(f_bold 'KDE Plasma')"
    return 0
  fi

  return 1
}

is_gnome() {
  local desktop_env="${XDG_CURRENT_DESKTOP:-}"

  if [[ "$desktop_env" == *'GNOME'* ]] \
    || [[ "${DESKTOP_SESSION:-}" == 'gnome' ]] \
    || pgrep -x 'gnome-shell' >/dev/null 2>&1; then

    p_debug "Обнаружено окружение: $(f_bold 'GNOME')"
    return 0
  fi

  return 1
}

is_xfce() {
  if [[ "${XDG_CURRENT_DESKTOP:-}" == *'XFCE'* ]] \
    || [[ "${DESKTOP_SESSION:-}" == 'xfce' ]] \
    || pgrep -x 'xfce4-session' >/dev/null 2>&1; then

    p_debug "Обнаружено окружение: $(f_bold 'XFCE')"
    return 0
  fi

  return 1
}


# =============================
# Функции поиска терминала по умолчанию
# -----------------------------
# Каждая функция ищет терминал, выбранный пользователем в настройках своего DE.
# Если настройка не найдена или указывает на отсутствующую программу,
# проверяются стандартные терминалы этого DE.
#
# Возвращает (stdout):
#   Путь до терминала: выбранного пользователем или стандартного для DE.
#
# Код возврата:
#   0 — установленный терминал найден.
#   1 — терминал не найден. Сообщение об ошибке не выводится,
#       его выдаёт вызывающий код.
# =============================

get_kde_default_terminal() {
  local kconfig_cmd=''
  local term_name=''

  if command -v kreadconfig6 >/dev/null 2>&1; then
    kconfig_cmd='kreadconfig6'
  elif command -v kreadconfig5 >/dev/null 2>&1; then
    kconfig_cmd='kreadconfig5'
  fi

  if [[ -n "$kconfig_cmd" ]]; then
    p_debug "Чтение конфига $(f_bold 'KDE Plasma') через $(f_bold "$kconfig_cmd")..."
    term_name="$(
      "$kconfig_cmd" \
        --file kdeglobals \
        --group General \
        --key TerminalApplication 2>/dev/null \
        || true
    )"

    if _print_executable "$term_name"; then
      return 0
    fi
    p_debug "Ключ $(f_bold 'TerminalApplication') пуст или указывает на отсутствующую программу."
  else
    p_debug "Утилиты $(f_bold 'kreadconfig') не найдены."
  fi

  p_debug "Возврат дефолтного терминала для $(f_bold 'KDE Plasma')"
  _print_executable konsole
}

get_gnome_default_terminal() {
  # Запасные терминалы GNOME в порядке приоритета
  local -a fallback_terminals=(
    'gnome-terminal'
    'kgx'     # исполняемый файл GNOME Console (пакет gnome-console)
    'ptyxis'  # терминал по умолчанию в новых версиях GNOME (Fedora)
  )
  local term_name=''
  local candidate

  if command -v gsettings >/dev/null 2>&1; then
    p_debug "Запрос $(f_bold 'gsettings get ...')"
    term_name="$(
      gsettings \
        get org.gnome.desktop.default-applications.terminal exec 2>/dev/null \
        || true
    )"
    term_name="${term_name//\'/}"  # Удаляем кавычки
    term_name="${term_name%% *}"   # Только первый токен

    # Ключ может быть устаревшим или указывать на неустановленный терминал,
    # поэтому результат проверяется на наличие в системе
    if _print_executable "$term_name"; then
      return 0
    fi
  else
    p_debug "Утилита $(f_bold 'gsettings') не найдена."
  fi

  p_debug "Возврат дефолтного терминала для $(f_bold 'GNOME')"
  for candidate in "${fallback_terminals[@]}"; do
    if _print_executable "$candidate"; then
      return 0
    fi
  done

  return 1
}

get_xfce_default_terminal() {
  local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/xfce4/helpers.rc"
  local custom_helper="${XDG_DATA_HOME:-$HOME/.local/share}"
  local term_name=''
  local custom_cmd=''
  custom_helper+='/xfce4/helpers/custom-TerminalEmulator.desktop'

  # XFCE хранит приложения по умолчанию (через exo) в helpers.rc
  if [[ -f "$config_file" ]]; then
    p_debug "Чтение файла: $(f_bold "$config_file")"
    term_name="$(
      grep -m1 '^TerminalEmulator=' "$config_file" \
        | cut -d'=' -f2 \
        || true
    )"
    p_debug "Найдено значение $(f_bold 'TerminalEmulator'): $(f_green "$term_name")"
  else
    p_debug "Файл конфигурации $(f_bold "$config_file") не найден."
  fi

  # Пользовательский терминал: команда берётся из desktop-файла
  if [[ "$term_name" == 'custom-TerminalEmulator' ]]; then
    if [[ -f "$custom_helper" ]]; then
      custom_cmd="$(
        grep -m1 '^Bin=' "$custom_helper" \
          | cut -d'=' -f2 \
          | awk '{print $1}' \
          || true
      )"
      p_debug "Команда из desktop-файла: $(f_bold "$custom_cmd")"
      if _print_executable "$custom_cmd"; then
        return 0
      fi
    fi
  elif _print_executable "$term_name"; then
    return 0
  fi

  p_debug "Возврат дефолтного терминала для $(f_bold 'XFCE')"
  _print_executable xfce4-terminal
}
