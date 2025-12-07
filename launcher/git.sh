#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail


# =============================
# Работа с сабмодулем
# -----------------------------
# $1 — путь к сабмодулю (например, "tools")
# $2 — корневая директория репозитория
# $3 — (опционально) ветка, на которую нужно переключиться (по умолчанию "main")
#
# Код возврата:
#   0 — сабмобуль успешно обновлён.
#   1 — аргументы не переданы или не удалось обновить сабмодуль.
# =============================
update_submodule() {
  local sub_path=$1
  local repo_root=$2
  local target_branch=${3:-"main"}

  if [[ -z "$sub_path" || -z "$repo_root" ]]; then
    e_error "update_submodule требует минимум 2 аргумента."
    return 1
  fi

  e_info "Для сабмодуля $(f_bold "$sub_path") будет использована ветка $(f_bold "$target_branch")."

  # 1. Получаем "логическое имя" сабмодуля по его пути.
  # Это нужно, чтобы правильно писать в конфиг git.
  local sub_name
  sub_name=$(git -C "$repo_root" submodule status "$sub_path" |
             sed 's/^.[0-9a-f]* //;s/ .*//')
  
  # Если сабмодуль еще не инициализирован, status может не вернуть имя. 
  # В таком случае берем имя из .gitmodules напрямую.
  if [[ -z "$sub_name" ]]; then
      sub_name=$(git -C "$repo_root" config --file .gitmodules --get-regexp path |
                 grep " $sub_path$" |
                 awk '{print $1}' |
                 sed 's/submodule\.//;s/\.path//')
  fi

  if [[ -z "$sub_name" ]]; then
      e_error "Не удалось определить имя сабмодуля для пути $sub_path"
      return 1
  fi

  # 2. Переопределяем ветку в локальном конфиге (.git/config)
  git -C "$repo_root" config "submodule.${sub_name}.branch" "$target_branch"

  # 3. Обновляем.
  # --remote заставит git посмотреть в конфиг (где мы только что сменили ветку),
  # сходить в origin и скачать последний коммит этой ветки.
  e_info "Обновление сабмодуля $(f_bold "$sub_name")..."
  if ! git -C "$repo_root" submodule update --init --remote -- "$sub_path"; then
    e_error "Не удалось обновить сабмодуль $sub_path."
    return 1
  fi

  e_done "$(f_green "Сабмодуль $(f_bold "$sub_path") успешно обновлен до" \
         "$(f_bold "origin $target_branch")")"
}
