#!/usr/bin/env python3
"""
Скрипт генерирует таблицы превью изображений внутри README.md файлов,
расположенных в поддиректориях каталога обоев. Все параметры берутся
из файла config.yml и инкапсулированы в классе TableGenerator.
"""
from pathlib import Path

import yaml


class TableGenerator:
    """
    Класс для управления процессом генерации таблиц Markdown в README.md
    на основе файлов конфигурации и структуры репозитория.
    """
    CONFIG_NAME: str = "config.yml"
    README_NAME: str = "README.md"

    def __init__(self, config_path: Path):
        """Загружает конфиг и инициализирует основные параметры."""
        # 1. Загрузка конфигурации
        self.config = self._load_config(config_path)

        # 2. Инициализация параметров
        self.wallpapers_dir = Path(self.config["wallpapers_dir"])
        self.exclude_dirs = set(self.config.get("exclude_dirs", []))
        self.allowed_extensions = [
            ext.lower() for ext in self.config["allowed_extensions"]
        ]
        self.opening_marker = self.config["opening_marker"]
        self.closing_marker = self.config["closing_marker"]
        self.columns = self.config["columns"]
        self.header_text = self.config.get("header", "")
        self.footer_text = self.config.get("footer", "")

    def _load_config(self, config_path: Path) -> dict:
        """Загружает YAML-конфигурацию."""
        with open(config_path, "r", encoding="utf-8") as file:
            return yaml.safe_load(file)

    def _find_readme_with_markers(
        self, readme_path: Path
    ) -> tuple[bool, str, str, str]:
        """
        Проверяет наличие маркеров в README.md.

        Возвращает:
            (found: bool, before: str, old_block: str, after: str)

        Если маркеры не найдены: found=False, остальные строки пустые.
        """
        content = readme_path.read_text(encoding="utf-8")

        start_index = content.find(self.opening_marker)
        end_index = content.find(self.closing_marker)

        if start_index == -1 or end_index == -1:
            return False, "", "", ""

        end_index += len(self.closing_marker)

        before_text = content[:start_index]
        generated_block = content[start_index:end_index]
        after_text = content[end_index:]

        return True, before_text, generated_block, after_text

    def _find_image_files(self, directory: Path) -> list[Path]:
        """
        Ищет изображения в указанной директории.

        Возвращает отсортированный список путей к найденным файлам.
        """
        image_files = []

        for entry in directory.iterdir():
            if entry.is_file():
                if entry.suffix.lower() in self.allowed_extensions:
                    image_files.append(entry)

        image_files.sort(key=lambda p: p.name)
        return image_files

    def _generate_table(self, image_files: list[Path], base_path: str) -> str:
        """
        Генерирует Markdown-таблицу с указанным количеством колонок.

        Формат ссылки:
            [![preview](path)](path)
        """
        if not image_files:
            return "_(В этой директории нет изображений)_"

        rows = []
        current_row = []

        for image_path in image_files:
            rel_path = f"{base_path}/{image_path.name}"
            cell = f"[![preview]({rel_path})]({rel_path})"
            current_row.append(cell)

            if len(current_row) == self.columns:
                rows.append("| " + " | ".join(current_row) + " |")
                current_row = []

        # последний неполный ряд
        if current_row:
            while len(current_row) < self.columns:
                current_row.append(" ")
            rows.append("| " + " | ".join(current_row) + " |")

        # 1. Скрытый заголовок
        hidden_header = "| " + " | ".join([""] * self.columns) + " |"

        # 2. Строка-разделитель после заголовка
        header_separator = "| " + " | ".join([":---:"] * self.columns) + " |"

        return hidden_header + "\n" + header_separator + "\n" + "\n".join(rows)

    def _build_generated_block(self, table: str) -> str:
        """
        Формирует итоговый вставляемый блок.

        Структура блока:
            {opening_marker}
            {header}

            {table}

            {footer}
            {closing_marker}
        """
        parts = [
            self.opening_marker,
            self.header_text,
            "",
            table,
            "",
            self.footer_text,
            self.closing_marker,
        ]

        return "\n".join(part for part in parts if part is not None)

    def process_directory(self, directory: Path) -> None:
        """
        Обрабатывает одну директорию обоев: ищет README.md, генерирует таблицу
        и заменяет блок между маркерами.
        """
        readme_path = directory / self.README_NAME

        if not readme_path.exists():
            return

        # Аргументы (маркеры) больше не передаются
        found, before_text, _, after_text = self._find_readme_with_markers(
            readme_path
        )
        if not found:
            return

        image_files = self._find_image_files(directory)

        # Формирование относительного пути для превью
        relative_path = directory.relative_to(self.wallpapers_dir)
        base_path = f"/{self.wallpapers_dir.name}/{relative_path}"

        table = self._generate_table(image_files, base_path)
        new_generated_block = self._build_generated_block(table)

        new_content = before_text + new_generated_block + after_text

        readme_path.write_text(new_content, encoding="utf-8")

    def run(self) -> None:
        """
        Основной цикл: проходит по поддиректориям и запускает обработку.
        """
        print(f"Начинается обработка каталога: {self.wallpapers_dir}")

        for subdir in self.wallpapers_dir.iterdir():
            if not subdir.is_dir():
                continue

            if subdir.name in self.exclude_dirs:
                print(
                    f"  -> Пропускается исключенная директория: {subdir.name}"
                )
                continue

            print(f"  -> Обработка директории: {subdir.name}")
            self.process_directory(subdir)

        print("Обработка завершена.")


def main() -> None:
    """
    Основная точка входа. Создает экземпляр TableGenerator и запускает его.
    """
    # Определяем путь к конфигу относительно скрипта
    file_dir = Path(__file__).resolve().parent
    config_path = file_dir.parent / TableGenerator.CONFIG_NAME

    # Инициализация и запуск
    try:
        generator = TableGenerator(config_path)
        generator.run()
    except FileNotFoundError:
        print(f"Ошибка: Файл конфигурации '{config_path}' не найден.")
    except KeyError as e:
        print(
            f"Ошибка: В конфигурационном файле '{TableGenerator.CONFIG_NAME}'"
            f" отсутствует обязательный ключ: {e}"
        )
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")


if __name__ == "__main__":
    main()
