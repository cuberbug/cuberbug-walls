#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail


declare -A DETECTORS=(
  ["KDE Plasma"]=is_kde
  ["GNOME"]=is_gnome
  ["XFCE"]=is_xfce
)
declare -A TERMINAL_GETTERS=(
  ["KDE Plasma"]=get_kde_default_terminal
  ["GNOME"]=get_gnome_default_terminal
  ["XFCE"]=get_xfce_default_terminal
)


# =============================
# Определение текущего графического окружения (DE)
# -----------------------------
# Функция выступает в роли диспетчера (Invoker). Она перебирает список известных
# окружений, зарегистрированных в глобальном массиве DETECTORS, и по очереди
# вызывает связанные с ними функции-проверки (стратегии).
#
# Принцип работы:
#   1. Берет пару "Название DE" -> "Функция проверки" из массива DETECTORS.
#   2. Запускает функцию проверки.
#   3. Если функция вернула успех (код 0), считается, что DE найдено.
#
# Зависимости:
#   Требует наличия глобального ассоциативного массива:
#     declare -A DETECTORS
#   Где ключ — название DE, а значение — имя функции для его проверки.
#
# Возвращает (stdout):
#   Имя найденного окружения (ключ из массива), например "KDE Plasma".
#
# Код возврата:
#   0 — Окружение успешно определено.
#   1 — Ни один из детекторов не сработал или массив DETECTORS пуст.
# =============================
detect_de() {
  local de

  # Перебираем все ключи (названия DE) из массива
  for de in "${!DETECTORS[@]}"; do
    # Запускаем функцию проверки, имя которой лежит в DETECTORS["$de"].
    # Если функция возвращает true (0), значит мы нашли нужное DE.
    if ${DETECTORS["$de"]}; then
      echo "$de"
      return 0
    fi
  done

  return 1
}


# =============================
# Поиск терминала по умолчанию для DE пользователя
# -----------------------------
# Принимает название окружения (DE), находит соответствующую функцию-стратегию
# в массиве TERMINAL_GETTERS и выполняет её для получения пути к терминалу.
#
# Параметры:
#   $1 — название DE (строка, обязательно). Например: "KDE Plasma".
#
# Возвращает (stdout):
#   Абсолютный путь к бинарному файлу терминала (например, "/usr/bin/konsole").
#
# Код возврата:
#   0 — терминал успешно найден.
#   1 — аргументы не переданы, DE не поддерживается или терминал не найден.
# =============================
get_terminal_for_de() {
  if [[ $# -ne 1 ]]; then
    e_error "$(f_bold "find_terminal_for_de") требует 1 аргумент — название DE."
    return 1
  fi

  local de="$1"
  local getter_func
  local term_path

  getter_func="${TERMINAL_GETTERS["$de"]}"

  if [[ -z "$getter_func" ]]; then
    e_debug "Для окружения '$de' нет определенной функции поиска терминала."
    return 1
  fi

  if term_path=$("$getter_func"); then
    if [[ -n "$term_path" ]]; then
      echo "$term_path"
      return 0
    fi
  fi

  e_debug "DE пользователя не поддерживается, либо его не удалось определить."
  return 1
}


# =============================
# Функции определения DE
# -----------------------------
# Поддерживаются:
#   - KDE Plasma
#   - GNOME
#   - XFCE
# =============================

is_kde() {
  if [[ "${XDG_CURRENT_DESKTOP:-}" == *"KDE"* ]] ||
    [[ "${DESKTOP_SESSION:-}" == "plasma" ]] ||
    [[ "${KDE_FULL_SESSION:-}" == "true" ]] ||
    pgrep -x "plasmashell" >/dev/null 2>&1; then

    e_debug "Обнаружено окружение: $(f_bold "KDE Plasma")"
    return 0
  fi
  return 1
}

is_gnome() {
  local desktop_env="${XDG_CURRENT_DESKTOP:-}"

  if [[ "$desktop_env" == *"GNOME"* ]] ||
    [[ "$desktop_env" == *"MATE"* ]] ||
    [[ "${DESKTOP_SESSION:-}" == "gnome" ]] ||
    pgrep -x "gnome-shell" >/dev/null 2>&1; then

    e_debug "Обнаружено окружение: $(f_bold "GNOME")"
    return 0
  fi
  return 1
}

is_xfce() {
  if [[ "${XDG_CURRENT_DESKTOP:-}" == *"XFCE"* ]] ||
    [[ "${DESKTOP_SESSION:-}" == "xfce" ]] ||
    pgrep -fx "xfce4-session" >/dev/null 2>&1; then

    e_debug "Обнаружено окружение: $(f_bold "XFCE")"
    return 0
  fi
  return 1
}


# =============================
# Вспомогательные функции поиска терминала
# -----------------------------
# Каждая из функций  пытается найти терминал по умолчанию в своём DE.
#
# Возвращает: путь до установленного пользователем терминала по умолчанию
#             или путь до дефолтного терминала.
# =============================

get_kde_default_terminal() {
  local de="KDE Plasma"
  local term_path
  local kconfig_cmd

  if command -v kreadconfig6 >/dev/null 2>&1; then
    kconfig_cmd="kreadconfig6"
  elif command -v kreadconfig5 >/dev/null 2>&1; then
    kconfig_cmd="kreadconfig5"
  fi

  if [[ -n "$kconfig_cmd" ]]; then
    e_debug "Чтение конфига $(f_bold "$de") через $(f_bold "$kconfig_cmd")..."
    term_path="$($kconfig_cmd --file kdeglobals --group General --key TerminalApplication)"

    if [[ -n "$term_path" ]]; then
      e_debug "Конфигурация вернула: $(f_green "$term_path")"
      echo "$term_path"
      return 0
    else
      e_debug "Ключ $(f_bold "TerminalApplication") пуст или не найден."
    fi
  else
    e_debug "Утилиты $(f_bold "kreadconfig") не найдены."
  fi

  # Попытка вернуть дефолт для KDE
  if term_path=$(command -v konsole) && [[ -n "$term_path" ]]; then
    e_debug "Возврат дефолтного терминала для $(f_bold "$de")"
    echo "$term_path"
    return 0
  fi

  e_error "Не удалось определить терминал для $(f_bold "$de")"
  return 1
}

get_gnome_default_terminal() {
  local de="GNOME"
  local term_path

  if command -v gsettings >/dev/null 2>&1; then
    e_debug "Запрос $(f_bold "'gsettings get ...'")"
    term_path="$(gsettings get org.gnome.desktop.applications terminal exec 2>/dev/null)"
    term_path="${term_path//\'/}"  # Удаляем кавычки
    term_path="${term_path%% *}"   # Берём только первый токен (на случай аргументов)

    if [[ -n "$term_path" ]]; then
      if command -v "$term_path" &>/dev/null; then
        e_debug "gsettings вернул: $(f_green "$term_path")"
        echo "$term_path"
        return 0
      fi
    fi
  else
    e_debug "Утилита $(f_bold "gsettings") не найдена."
  fi

  # Попытка вернуть дефолт для GNOME
  if term_path=$(command -v gnome-terminal) && [[ -n "$term_path" ]]; then
    e_debug "Возврат дефолтного терминала для $(f_bold "$de")"
    echo "$term_path"
    return 0
  fi

  e_error "Не удалось определить терминал для $(f_bold "$de")"
  return 1
}

get_xfce_default_terminal() {
  local config_file="$HOME/.config/xfce4/helpers.rc"
  local de="XFCE"
  local term_path

  # XFCE хранит настройки приложений по умолчанию (через exo) в helpers.rc
  if [[ -f "$config_file" ]]; then
    e_debug "Чтение файла: $(f_bold "$config_file")"
    term_path=$(grep "^TerminalEmulator=" "$config_file" | cut -d'=' -f2)
    e_debug "Найдено значение $(f_bold "TerminalEmulator"): $(f_green "$term_path")"
  else
    e_debug "Файл конфигурации $(f_bold "$config_file") не найден."
  fi

  # Проверяем значения из 'helpers.rc'
  if [[ -n "$term_path" ]] && command -v "$term_path" >/dev/null 2>&1; then
    e_debug "$(f_bold "helpers.rc") вернул: $(f_green "$term_path")"
    echo "$term_path"
    return 0
  # Или 'custom-TerminalEmulator.desktop'
  elif [[ "$term_path" == "custom-TerminalEmulator" ]]; then
    local custom_helper="$HOME/.local/share/xfce4/helpers/custom-TerminalEmulator.desktop"

    e_debug "Обнаружен $(f_bold "custom-TerminalEmulator")," \
              "запуск проверки: $(f_bold "$custom_helper")"

    if [[ -f "$custom_helper" ]]; then
      local custom_cmd

      custom_cmd=$(grep "^Bin=" "$custom_helper" | cut -d'=' -f2 | awk '{print $1}')
      e_debug "Извлечена команда из desktop-файла: $(f_bold "$custom_cmd")"

      if [[ -n "$custom_cmd" ]] && command -v "$custom_cmd" >/dev/null 2>&1; then
        e_debug "$(f_bold "custom-TerminalEmulator.desktop") вернул: $(f_green "$custom_cmd")"
        echo "$custom_cmd"
        return 0
      fi
    fi
  fi

  # Попытка вернуть дефолт для XFCE
  if term_path=$(command -v xfce4-terminal) && [[ -n "$term_path" ]]; then
    e_debug "Возврат дефолтного терминала для $(f_bold "$de")"
    echo "$term_path"
    return 0
  fi

  e_error "Не удалось определить терминал для $(f_bold "$de")"
  return 1
}
