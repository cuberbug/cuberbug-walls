<h1 align="center">₍^. ̫ .^₎⟆</h1>

## Что это такое?

Здесь находится моя личная коллекция обоев для рабочего стола и пространство для экспериментов в автоматизации и программировании.

![](wallpapers/other/1758582317.jpg)

---

## Инструменты

В репозитории доступно несколько инструментов, облегчающих управление коллекцией за счёт автоматизации некоторых рутинных процессов. Доступ к ним можно получить запустив скрипт `manager.sh`

### Зависимости

- <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAMAAABF0y+mAAAAMFBMVEVHcEz0TCf5TijxSyb1TSf5TifrSSX2TSf0TCf2TSf6TijrSSX0TCf4TSf7TyjsSSU79qcKAAAADHRSTlMA4e4iR1YQO820ZICAJSLHAAAA6ElEQVQokXWSWRLEIAhEAfdE9P63HcDSLGO6kvy8NNIIwE0+Zw8fCtQahW/2SQ+DDTc0+En/vYEwwdH7jiZmFhpdMXN6+FiVHYAbpcO9pkFUmF/nBmSuVd7z6nnSgEqEcY3RPxMpEypP6zGK48g4vYmqSZ0CO3pwo2dKMH36UcglAkTLi5DrFPOA2rPBLMEWHc56upGH5C+Py2qQKyI3bmhXu6hGsVCNJ7tolyGcnce01kr4ca7NNhuj27okgzZbZK38uBZntEh8M7rXhVrl3nWMlOClKxFu1nPSHZt0z0Yi+lx5V8qjzx+XBhDROe95mQAAAABJRU5ErkJggg==" width="16" height="16"> [Git](https://git-scm.com)
- <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAMAAABF0y+mAAAAh1BMVEVHcEwBVJc3caE2bJdKir3z2mL/6m05daZAfa5Jd5nsyUUqbKFHZ3flw0Towzv+2Uz842rmwTgANYDeuzlFgrL/6nD94WL20ETvxzf50T5Jh7lAfKxAf7E9eqv/5GX/4Fz/6HH/3VNFhbc1cKD/2kowapr/1Dj/10H+/v786a2dt851nL7c5OukoiX2AAAAHHRSTlMAf0dz/ovF/qRkVcoZX2noqUpnMo7r88Ww1sbqk9MnjgAAAR1JREFUKJFl0etygyAQBWCCEIJGozE1TWu9C8b2/Z+vsEscA+ef882RXSBky5nKKJL0TMJINrBhGOr6JwmYMrYCmQhfb8PfstYWhRhlgOvya3vCYBRgPWJPjAHSEwTsDeVpC9h8zfOc41RfjMES7p/jPF8/uq6r4DSwGocBQ2y4Qay5JcAsNk1zMZcW2iwNtW1rr2Yz4eyQg/UlkS9LDi4SrO/7AtGY5EeXCmr9NMWE4qDRscM0rjZNuiQEl0h3BLVJa7PKNxzI/ZrWd4ORHRTwVQNTqrBXlJgdLL79UqlP9yJSUg5WZbFNmmVZsXsZjqddbHTqvSffJmmVynx0p6nn8gwwdZMAFh6SOy6n1DbnW/eB9PDHcSnjotx//wNQ0jN2CWQnkAAAAABJRU5ErkJggg==" width="16" height="16"> [Python](https://www.python.org)
- <img src="https://avatars.githubusercontent.com/u/57376114?s=48&v=4" width="16" height="16"> [gum](https://github.com/charmbracelet/gum) — инструмент для оформления TUI, используется в `manager.sh`

### Git-manager

>Рекомендуется использовать `manager.sh`! Ручной запуск скриптов с основной логикой возможен в случае, если в системе отсутствует пакет `gum`.

Взаимодействие с Git автоматизировано посредством двух скриптов:
- `push.sh`: Автоматически составит коммит и отправит его в репозиторий.
- `pull.sh`: Загрузит актуальное состояние удалённого репозитория.

При ручном запуске `push.sh` из терминала доступно указание параметров для команды `git push <параметр>`. Например так:
```shell
# Выполнить принудительную отправку изменений в удалённый репозиторий
# (выполняется из корневой директории репозитория)
./tools/git-manager/push.sh --force
```
Время для автоматических коммитов указывается в формате UTC.

#### Поддерживаемые терминалы

- <img src="https://konsole.kde.org/assets/img/app_icon.png" width="16" height="16"> Konsole
- <img src="https://gitlab.gnome.org/uploads/-/system/project/avatar/1892/gt.png?width=48" width="16" height="16"> GNOME Terminal
- <img src="https://gitlab.gnome.org/GNOME/console/-/raw/main/logo.png?ref_type=heads" width="16" height="16"> Console
- <img src="https://docs.xfce.org/_media/xfce/xfce.terminal.png" width="16" height="16"> xfce4-terminal
- <img src="https://sw.kovidgoyal.net/kitty/_static/kitty.svg" width="16" height="16"> kitty
- <img src="https://alacritty.org/alacritty-simple.svg" width="16" height="16"> Alacritty
- <img src="https://invisible-island.net/img/icons/xterm.ico" width="16" height="16"> XTerm

Наличие эмулятора терминала проверяется в указаной выше последовательности. Скрипты с основной логикой будут выполняться в первом найденном терминале. Для расширения поддерживаемого списка терминалов можно обраиться ко мне в [issues](https://github.com/cuberbug/cuberbug-walls/issues).

### Renamer

[Renamer](tools/renamer) — это скрипт на Python, предназначенный для **автоматического переименования** всех файлов-изображений в указанной директории и её поддиректориях.

Он заменяет исходные имена на **временную метку UNIX** (время последней модификации файла), приводя их к формату: `<timestamp>.<расширение>`. Это обеспечивает **единый стиль именования** и позволяет легко сортировать коллекцию по дате сохранения.

**Пример использования:** (Linux)
```bash
# Перейти в директорию со скриптом
cd tools/renamer
# Запуск в режиме предварительной проверки (Dry Run)
python3 main.py /путь/к/коллекции --dry-run
# Реальное переименование
python3 main.py /путь/к/коллекции
```

---

### Именные директории _(beta)_

В моей коллекции со временем будут появляться директории, связанные с конкретными людьми, будь то источники или художники и их работы. В таком случае к каждой именной директории будет добавлен свой `README.md` с описанием и ссылками, если это возможно. Возможно вам захочется связаться с автором, выразить ему благодарность или что-то предложить — не стесняйтесь воспользоваться такой возможностью!


### Спасибо? Спасибо!

Выражаю благодарность [Жоре](https://github.com/Katze-942) за помощь с идеями! ❤️
