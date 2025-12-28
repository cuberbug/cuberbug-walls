<h1 align="center">₍^. ̫ .^₎⟆</h1>

## 🐾 Что это такое?

Коллекция обоев для рабочего стола и пространство экспериментов в автоматизации и программировании!  
Здесь вы сможете как насладиться красивыми изображениями, так и попробовать набор инструментов, написанных специально для удобного управления этим репозиторием.

<table>
  <thead>
    <tr>
      <th style="white-space: nowrap;"><b>🐾 Навигация</b></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center" style="white-space: nowrap;">
        <a href="./wallpapers/desktop/README.md">🖥️ desktop</a>
      </td>
      <td rowspan=12 align="center">
        <a href="./wallpapers/desktop/1762262506.webp">
          <img
            src="./.previews/menu.webp"
            alt="Cute cat-girl"
          >
        </a>
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
    <tr>
      <td align="center" style="white-space: nowrap;">
        <a href="./wallpapers/artists/HOJI/README.md">HOJI</a>
      </td>
    </tr>
    <tr>
      <td align="center" style="white-space: nowrap;">
        <a href="./wallpapers/artists/Nakkar7/README.md">Nakkar7</a>
      </td>
    </tr>
  </tbody>
</table>

### 🐾 А где?

А вот! Все картинки находятся внутри `./wallpapers/` и отсортированы по типам и формату:

```shell
/cuberbug-walls/
└── wallpapers   # Коллекция обоев
    ├── artists    # Именные директории для художников
    │   ├── Grym3ik  # Необычный стиль, вызывающий необычные эмоции
    │   ├── HOJI     # Потрясающая детализация
    │   └── Nakkar7  # Милое сочетание фотографии и графики
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
* [ImageMagick](https://github.com/nihui/waifu2x-ncnn-vulkan) для создания превью
* [waifu2x-ncnn-vulkan](https://github.com/nihui/waifu2x-ncnn-vulkan) для апскейлинга

Для автоматической генерации таблиц с превью используется скрипт `./src/tables_generator.py` и GitHub Actons. Он активируется после обновления директории с превью, которая управляется мною при помощи локальных скриптов.

---

# 🛠️ Инструменты

>Сразу после клонирования директория `./tools/` будет пуста: всё так и должно быть! Если вам не хочется устанавливать инструменты — просто не запускайте `tool-launcher`.

Чтобы начать пользоваться инструментами, запустите скрипт `tool-launcher` из корня репозитория (например, `./tool-launcher`). Он всё сделает сам:

* **Автоматически** загрузит или обновит набор инструментов **Repo-Tools** в директорию `./tools/`.
* **Запустит TUI-меню** (`./tools/start`) в новом окне терминала, если вы запустили его двойным кликом (тихий режим), или прямо в текущем, если запустили его командой в терминале.

Всё готово к использованию! **Repo-Tools** предложит вам установить виртуальное окружение и необходимые зависимости, чтобы вы сразу могли перейти к работе.

![Скриншот меню](/.previews/1762284703.webp)

### 🐾 Технические детали

`tool-launcher` поддерживает использование опций:

* `--help`: покажет справочную информацию
* `--version`: покажет версию скрипта
* `--debug`: режим отладки с принудительным запуском целевого скрипта в новом окне терминала
* `--no-window`: отмена принудительного запуска целевого скрипта в новом окне терминала (только в режиме отладки)
* `--no-color`: активация режима бесцветного вывода текста в терминал, поддерживается переменная окружения `NO_COLOR`
* `--branch [NAME]`: позволяет при запуске загрузить версию утилит из указанной ветки

```shell
# Запуск в режиме отладки с бесцветным выводом
./tool-launcher --debug --no-color

# Запуска утилит из dev ветки
./tool-launcher --branch dev
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
<!-- * <img src="https://projects.linuxmint.com/icons/projects/cinnamon-logo.svg" width="18" height="18"> Cinnamon -->
<!-- * <img src="https://cdn11.bigcommerce.com/s-pywjnxrcr2/product_images/system76_logo-fav-32x32.png" width="18" height="18"> COSMIC -->

## ⚙️ **Repo-Tools**

[**Repo-Tools**](https://github.com/cuberbug/repo-tools) — это отдельный репозиторий с набором инструментов, подключающийся сюда посредством установки сабмодуля.
Для этого достаточно запустить `./tool-launcher` — он всё сделает сам, а содержимое репозитория **Repo-Tools** окажется в директории `./tools/`, после чего будет запущен скрипт `./tools/start`, который предложет автоматически установить виртуальное окружение Python вместе с зависимостями и предложит запустить интерактивное TUI-меню, в котором доступен запуск любого из инструментов.

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

В коллекции со временем будут появляться директории, связанные с конкретными людьми, будь то источники или художники и их работы. В таком случае к каждой именной директории будет добавлен свой `README.md` с описанием и ссылками, если это возможно.

## 🐾 Спасибо? Спасибо!

Выражаю благодарность:
* [Жоре](https://github.com/Katze-942) за помощь с идеями! ❤️
* [КОМЕТЕ](https://github.com/KN13KOMETA) за вклад и новый вектор для развития! ☄️
