<h1 align="center">₍^. ̫ .^₎⟆</h1>

## 🐾 Что это такое?

Здесь находится моя личная коллекция обоев для рабочего стола и пространство экспериментов в автоматизации и программировании! Здесь вы сможете как насладиться красивыми изображениями, так и попробовать набор инструментов, написанных специально для удобного управления этим репозиторием.

<table>
  <thead>
    <tr>
      <th style="white-space: nowrap;"><b>🐾 Навигация</b></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center" style="white-space: nowrap;">Директории</td>
      <td rowspan=10 align="center">
        <a href="./wallpapers/other/1762278931.webp">
          <img
            src="./wallpapers/other/1762278931.webp"
            alt="Cute cat-girl"
          >
        </a>
      </td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;"><a href="./wallpapers/">📁 wallpapers</a></td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;"><a href="./wallpapers/artists/">📁 artists</a></td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;">Превью</td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;">
        <a href="./wallpapers/desktop/README.md">🖥️ desktop</a>
      </td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;">
        <a href="./wallpapers/mobile/README.md">📱 mobile</a>
      </td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;">
        <a href="./wallpapers/other/README.md">☁️ other</a>
      </td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;">Художники</td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;">
        <a href="./wallpapers/artists/Grym3ik/README.md">Grym3ik</a>
      </td>
    </tr>
      <td align="center">
        <img
          src="./.previews/1763526658.webp"
          alt="Cute microcat-girl"
        >
      </td>
  </tbody>
</table>

### 🐾 А где?

А вот! Все картинки находятся внутри `./wallpapers/` и отсортированы по типам и формату:

```shell
/cuberbug-walls/
└── wallpapers   # Коллекция обоев в высоком разрешении
    ├── artists    # Именные директории для художников
    │   └── Grym3ik  # Содержит подробную информацию и галерею
    ├── bucket     # Корзина: файлы в ней будут удалены через некоторое время
    ├── contrib    # Для предложений ваших изображений в коллекцию
    ├── desktop    # Горизонтальный формат
    ├── mobile     # Вертикальный формат
    └── other      # Изображения без категории
```

### 🐾 Клонирование

Со временем в репозитории может накапливаться мусор, поэтому рекомендую использовать дополнительный параметр `--depth`
```shell
git clone --depth 1 https://github.com/cuberbug/cuberbug-walls.git
```

#### 🐾 Технические детали

Для оптимизации хранения используются инструменты апскейлинга и сжатия изображений.

* [WebP](https://developers.google.com/speed/webp?hl=ru) выбранный мною формат в качестве основного
    * [cwebp](https://developers.google.com/speed/webp/docs/cwebp?hl=ru) для работы со сжатием
* [ImageMagick](https://github.com/nihui/waifu2x-ncnn-vulkan) иногда используется для конвертации
* [waifu2x-ncnn-vulkan](https://github.com/nihui/waifu2x-ncnn-vulkan) для апскейлинга

Для автоматической генерации таблиц с превью используется скрипт `./src/tables_generator.py` и GitHub Actons. Он активируется после обновления директории с превью, которая управляется мною при помощи локальных скриптов.

---

# 🛠️ Инструменты

>Сразу после клонирования директория `./tools/` будет пуста: всё так и должно быть! Если тебе не хочется устанавливать инструменты — просто не запускайте `tool-launcher`.

Чтобы начать пользоваться инструментами, запустите скрипт `tool-launcher` из корня репозитория (например, `./tool-launcher`). Он всё сделает сам:

* **Автоматически** загрузит или обновит набор инструментов **Repo-Tools** в директорию `./tools/`.
* **Запустит TUI-меню** (`./tools/start.sh`) в новом окне терминала, если вы запустили его двойным кликом (тихий режим), или прямо в текущем, если запустили его командой в терминале.

Всё готово к использованию! **Repo-Tools** предложит вам установить виртуальное окружение и необходимые зависимости, чтобы вы сразу могли перейти к работе.

![Скриншот меню](wallpapers/other/1762284703.webp)

### 🐾 Технические детали

`tool-launcher` поддерживает ключи для работы с ним:

* `--help` или `-h` — покажет справочную информацию
* `--version` или `-v` — покажет версию скрипта
* `--debug` или `-d` — режим отладки с принудительным запуском целевого скрипта в новом окне терминала
* `--no-color` или `-N` — активация режима бесцветного вывода текста в терминал

Пример запуска в режиме отладки с бесцветным выводом:
```shell
./tool-launcher --debug --no-color
```

#### 🐾 Тихий режим

Если вы запустили `tool-launcher` двойным кликом, он автоматически определит ваш **Desktop Environment** или переберёт список поддерживаемых терминалов, чтобы открыть TUI-меню в новом окне.

## 🐾 Зависимости

* <img src="https://www.svgrepo.com/show/303548/git-icon-logo.svg" width="18" height="18"> [Git](https://git-scm.com)
* <img src="https://www.svgrepo.com/show/452091/python.svg" width="18" height="18"> [Python](https://www.python.org) ≥ 3.10

### 🐾 Debian / Ubuntu

Для работы с виртуальным окружением требуется установить пакет `python3-venv`:
```shell
sudo apt install python3-venv
```

### 🐾 Поддерживаемые DE

* <img src="https://kde.org/stuff/clipart/logo/kde-logo-white-gray-128x128.png" width="18" height="18"> KDE Plasma
* <img src="https://gitlab.gnome.org/GNOME/gnome-boxes-logos/-/raw/master/logos/gnome-logo.svg" width="18" height="18"> GNOME
* 🐁 XFCE

## ⚙️ **Repo-Tools**

[**Repo-Tools**](https://github.com/cuberbug/repo-tools) — это отдельный репозиторий с набором инструментов, подключающийся сюда посредством установки сабмодуля. Для его установки достаточно запустить `./manager.sh` — он всё сделает сам, а содержимое репозитория **Repo-Tools** окажется в директории `./tools/`, после чего в новом окне терминала будет запущен скрипт `./tools/start.sh`, который предложет автоматически установить виртуальное окружение Python в `./tools/.venv`, установит все необходимые зависимости и предложит запустить интерактивное TUI-меню, в котором доступен запуск любого из инструментов.

### 🐾 Menu

Интерактивное меню — это первое, что встретит вас после запуска инструментов. Вот что оно умеет:
* выполнять Git-операции (`push` / `pull`) через модуль **GitOps**;
* запускать [**Renamer**](https://github.com/cuberbug/repo-tools/blob/main/apps/renamer/README.md) для автоматического переименования изображений;
* быстро переключаться между режимами работы и завершать программу.

#### 🐾 А ещё?

Можно и ещё! Подробнее об инструментах вы можете почитать в [README.md](https://github.com/cuberbug/repo-tools/blob/main/README.md) репозитория [**Repo-Tools**](https://github.com/cuberbug/repo-tools).

---

<h1 align="center">🌾 🌾 🌾 ₍^. ̫ .^₎⟆ 🌾 🌾 🌾</h1>

## 🐾 Именные директории

В моей коллекции со временем будут появляться директории, связанные с конкретными людьми, будь то источники или художники и их работы. В таком случае к каждой именной директории будет добавлен свой `README.md` с описанием и ссылками, если это возможно. Если вам захочется связаться с автором, выразить ему благодарность или что-то предложить — не стесняйтесь этим воспользоваться!

## 🐾 Спасибо? Спасибо!

Выражаю благодарность:
* [Жоре](https://github.com/Katze-942) за помощь с идеями! ❤️
* [КОМЕТЕ](https://github.com/KN13KOMETA) за вклад и новый вектор для развития! ☄️
