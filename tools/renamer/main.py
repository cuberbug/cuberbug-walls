import argparse
import os
import sys

from src.core import rename_files


def main():
    """
    Основная функция-точка входа в программу.
    Обрабатывает аргументы командной строки и запускает логику переименования.
    """
    # 1. Создаем парсер аргументов
    parser = argparse.ArgumentParser(
        description="Переименовывает файлы-изображения в указанной директории, "
                    "используя время их создания в качестве имени."
    )
    
    # 2. Добавляем аргументы
    parser.add_argument(
        "directory",
        metavar="DIRECTORY",
        type=str,
        help="Путь к директории, которую нужно обработать."
    )
    
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Выводит список файлов, которые будут переименованы, но не выполняет переименование."
    )
    
    # 3. Парсим аргументы, переданные при запуске скрипта
    args = parser.parse_args()
    
    # 4. Проверяем, существует ли указанная директория
    if not os.path.isdir(args.directory):
        print(f"Ошибка: Директория '{args.directory}' не найдена.")
        sys.exit(1)

    # 5. Запускаем нашу основную логику, передавая ей аргументы
    rename_files(args.directory, args.dry_run)

if __name__ == "__main__":
    main()
