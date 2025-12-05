#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail


# =============================
# Поиск терминала по умолчанию для DE пользователя
# -----------------------------
# Если удалось опредеить DE пользователя, то запустит для него поиск терминала по умолчанию.
#
# Возвращает: путь до бинарника найденного терминала
#             или ничего.
find_terminal_for_de() {
  if is_kde; then
    # shellcheck disable=SC2034
    TERMINAL_FOR_DE="$(get_kde_default_terminal)"
    return 0
  elif is_gnome; then
    # shellcheck disable=SC2034
    TERMINAL_FOR_DE="$(get_gnome_default_terminal)"
    return 0
  elif is_xfce; then
    # shellcheck disable=SC2034
    TERMINAL_FOR_DE="$(get_xfce_default_terminal)"
    return 0
  else
    e_debug "DE пользователя не поддерживается, либо его не удалось определить."
    return 1
  fi
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
    DE="KDE Plasma"
    e_debug "Обнаружено окружение: $(f_bold "$DE")"
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
    DE="GNOME"
    e_debug "Обнаружено окружение: $(f_bold "$DE")"
    return 0
  fi
  return 1
}

is_xfce() {
  if [[ "${XDG_CURRENT_DESKTOP:-}" == *"XFCE"* ]] ||
    [[ "${DESKTOP_SESSION:-}" == "xfce" ]] ||
    pgrep -fx "xfce4-session" >/dev/null 2>&1; then
    DE="XFCE"
    e_debug "Обнаружено окружение: $(f_bold "$DE")"
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
  local term_bin kconfig_cmd

  if command -v kreadconfig6 >/dev/null 2>&1; then
    kconfig_cmd="kreadconfig6"
  elif command -v kreadconfig5 >/dev/null 2>&1; then
    kconfig_cmd="kreadconfig5"
  fi

  if [[ -n "$kconfig_cmd" ]]; then
    e_debug "Чтение конфига $(f_bold "$DE") через $(f_bold "$kconfig_cmd")..."
    term_bin="$($kconfig_cmd --file kdeglobals --group General --key TerminalApplication)"

    if [[ -n "$term_bin" ]]; then
      e_debug "Конфигурация вернула: $(f_green "$term_bin")"
      echo "$term_bin"
      return 0
    else
      e_debug "Ключ $(f_bold "TerminalApplication") пуст или не найден."
    fi
  else
    e_debug "Утилиты $(f_bold "kreadconfig") не найдены."
  fi

  # Попытка вернуть дефолт для KDE
  if term_bin=$(command -v konsole) && [[ -n "$term_bin" ]]; then
    e_debug "Возврат дефолтного терминала для $(f_bold "$DE")"
    echo "$term_bin"
    return 0
  fi

  e_error "Не удалось определить терминал для $(f_bold "$DE")"
  return 1
}

get_gnome_default_terminal() {
  local term_bin

  if command -v gsettings >/dev/null 2>&1; then
    e_debug "Запрос $(f_bold "'gsettings get ...'")"
    term_bin="$(gsettings get org.gnome.desktop.applications terminal exec 2>/dev/null)"
    term_bin="${term_bin//\'/}"  # Удаление кавычек
    term_bin="${term_bin%% *}"   # Берёт только первый токен (на случай аргументов)

    if [[ -n "$term_bin" ]]; then
      if command -v "$term_bin" &>/dev/null; then
        e_debug "gsettings вернул: $(f_green "$term_bin")"
        echo "$term_bin"
        return 0
      fi
    fi
  else
    e_debug "Утилита $(f_bold "gsettings") не найдена."
  fi

  # Попытка вернуть дефолт для GNOME
  if term_bin=$(command -v gnome-terminal) && [[ -n "$term_bin" ]]; then
    e_debug "Возврат дефолтного терминала для $(f_bold "$DE")"
    echo "$term_bin"
    return 0
  fi

  e_error "Не удалось определить терминал для $(f_bold "$DE")"
  return 1
}

get_xfce_default_terminal() {
  local config_file="$HOME/.config/xfce4/helpers.rc"
  local term_bin

  # XFCE хранит настройки приложений по умолчанию (через exo) в helpers.rc
  if [[ -f "$config_file" ]]; then
    e_debug "Чтение файла: $(f_bold "$config_file")"
    term_bin=$(grep "^TerminalEmulator=" "$config_file" | cut -d'=' -f2)
    e_debug "Найдено значение $(f_bold "TerminalEmulator"): $(f_green "$term_bin")"
  else
    e_debug "Файл конфигурации $(f_bold "$config_file") не найден."
  fi

  # Проверка значения из 'helpers.rc'
  if [[ -n "$term_bin" ]] && command -v "$term_bin" >/dev/null 2>&1; then
    e_debug "$(f_bold "helpers.rc") вернул: $(f_green "$term_bin")"
    echo "$term_bin"
    return 0
  # Или 'custom-TerminalEmulator.desktop'
  elif [[ "$term_bin" == "custom-TerminalEmulator" ]]; then
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
  if term_bin=$(command -v xfce4-terminal) && [[ -n "$term_bin" ]]; then
    e_debug "Возврат дефолтного терминала для $(f_bold "$DE")"
    echo "$term_bin"
    return 0
  fi

  # Если совсем ничего не нашли (крайний случай)
  e_error "Не удалось определить терминал для $(f_bold "$DE")"
  return 1
}
