#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail


# =============================
# Работа с сабмодулем
# -----------------------------
# Обновляет сабмодуль до актуального состояния
#   $1 — название сабмодуля из конфигурации .gitmodules (обязательно)
#   $2 — путь к директории, из которой команда будет выполнена (обязательно)
# =============================
update_submodule() {
  if [[ $# -ne 2 ]]; then
    e_error "$(f_bold "update_submodule") требует 2 аргумент — имя сабмодуля и путь к репозиторию."
    return 1
  fi

  local submodule_name=$1
  local path=$2

  e_info "Проверка и обновление сабмодуля $(f_bold "$submodule_name")..."

  if ! git -C "$path" submodule update --init --remote -- "$submodule_name"; then
    e_error "Не удалось обновить сабмодуль $submodule_name."
    return 1
  fi

  e_done "$(f_green "Сабмодуль успешно обновлен или уже актуален")"
}
