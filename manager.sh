#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Определяет путь до исполняемого файла и переходит в его директорию
MAIN_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$MAIN_PATH" || exit 1

# Настройка сабмодуля
REPO_TOOLS_PATH="tools"


# --- Функции ---

# Ищет первый доступный терминал из списка и возвращает путь до его бинарника
find_terminal() {
  # Ищем терминал в KDE приложениях по умолчанию
  local kde_terminal="$(cat ~/.config/kdeglobals | grep TerminalApplication | sed 's/.*=//')"

  if [[ -n "$kde_terminal" ]]; then
    echo "$kde_terminal"
    return 0
  fi

  local terminals_to_check=(
    "konsole"        # Многофункциональный терминал для среды KDE
    "gnome-terminal" # Стандартный терминал для среды GNOME
    "gnome-console"  # Легковесный терминал для GNOME, замена gnome-terminal
    "xfce4-terminal" # Легковесный терминал, идущий в комплекте с XFCE
    "kitty"          # Быстрый, настраиваемый терминал с поддержкой GPU
    "alacritty"      # Легковесный, высокопроизводительный терминал с акцентом на простоту
    "xterm"          # Классический, минималистичный терминал для X Window System
  )

  for terminal in "${terminals_to_check[@]}"; do
    if command -v "$terminal" &>/dev/null; then
      echo "$terminal"
      return 0
    fi
  done

  return 1
}

# Обновляет сабмодуль до актуального состояния
#   $1 — путь до сабмодуля (обязательно)
update_submodule() {
  local submodule_path=$1

  echo ":: Проверка и обновление сабмодуля '$submodule_path'..."

  if git submodule update --init --remote -- "$submodule_path" &>/dev/null; then
    echo ":: Сабмодуль успешно обновлен или уже актуален."
  else
    git_output=$(git submodule update --init --remote -- "$submodule_path" 2>&1)

    echo "Ошибка: Не удалось обновить сабмодуль '$submodule_path'." >&2
    echo "Подробности ошибки Git:" >&2
    echo "$git_output" >&2

    # Можно уронить в критичных случаях:
    # exit 1 
  fi
}


# --- Подготовка ---

# Определяет корневую директорию репозитория и терминал для запуска основной логики
REPO_ROOT="$(git rev-parse --show-toplevel)"
TARGET_SCRIPT="${REPO_ROOT}/tools/start.sh"

# Обновление сабмодуля repo-tools
update_submodule "$REPO_TOOLS_PATH"


# --- Основная логика запуска ---

# Проверяем запускается ли скрипт из интерактивного окружения
if test -t 0; then
  echo ":: Запуск интерактивного меню..."
  $TARGET_SCRIPT
else
  TERMINAL=$(find_terminal)

  if [[ -z "$TERMINAL" ]]; then
    echo "Ошибка: Не удалось найти поддерживаемый эмулятор терминала." >&2
    exit 1
  fi

  # Запускает скрипт с основной логикой в новом окне терминала
  echo ":: Запуск интерактивного меню в новом окне ($TERMINAL)..."
  $TERMINAL -e "$TARGET_SCRIPT"
fi
