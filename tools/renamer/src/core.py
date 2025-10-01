import os
import shutil
import sys

from .utils import is_image, is_already_renamed, generate_new_filename

def rename_files(directory: str, dry_run: bool = False):
    """
    Рекурсивно переименовывает файлы-изображения в указанной директории.

    Args:
        directory: Путь к директории, которую нужно обработать.
        dry_run: Если True, скрипт выведет, что будет сделано, но не будет
                 реально переименовывать файлы.
    """
    if not os.path.isdir(directory):
        print(f"Ошибка: Директория '{directory}' не существует.")
        sys.exit(1)

    renamed_count = 0
    skipped_count = 0

    print(f"Сканирование директории: '{directory}'...")
    if dry_run:
        print("Включен режим 'сухого запуска'. Файлы не будут переименованы.")

    for root, _, files in os.walk(directory):
        for filename in files:
            full_path = os.path.join(root, filename)

            if not is_image(full_path):
                continue

            if is_already_renamed(filename):
                skipped_count += 1
                continue

            try:
                # Получает время последней модификации в секундах
                timestamp = int(os.path.getmtime(full_path))

                # Формирует новое имя и путь
                new_filename = generate_new_filename(filename, timestamp)
                new_full_path = os.path.join(root, new_filename)

                # Проверяет, не существует ли уже файл с таким именем
                while os.path.exists(new_full_path):
                    # Если существует, увеличивает метку и генерирует новое имя
                    timestamp += 1
                    new_filename = generate_new_filename(filename, timestamp)
                    new_full_path = os.path.join(root, new_filename)

                print(f"Переименование '{filename}' -> '{os.path.basename(new_full_path)}'")

                if not dry_run:
                    shutil.move(full_path, new_full_path)
                    renamed_count += 1
            except Exception as e:
                print(f"Ошибка при обработке файла '{full_path}': {e}")

    print("\n---")
    print("Результаты:")
    print(f"Переименовано файлов: {renamed_count}")
    print(f"Пропущено файлов (уже переименованы): {skipped_count}")
