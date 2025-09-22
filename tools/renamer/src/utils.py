import os

# Список поддерживаемых расширений изображений.
# Используем нижний регистр для единообразия.
SUPPORTED_EXTENSIONS: set = {
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp'
}

def is_image(filepath: str) -> bool:
    """
    Проверяет, является ли файл изображением на основе его расширения.
    
    Args:
        filepath: Полный путь к файлу.
    
    Returns:
        True, если расширение файла находится в списке поддерживаемых, иначе False.
    """
    _, file_extension = os.path.splitext(filepath)
    return file_extension.lower() in SUPPORTED_EXTENSIONS


def is_already_renamed(filename: str) -> bool:
    """
    Проверяет, соответствует ли имя файла формату <timestamp>.<расширение>.
    
    Args:
        filename: Имя файла.
    
    Returns:
        True, если имя файла соответствует формату, иначе False.
    """
    try:
        name, extension = os.path.splitext(filename)
        # Проверяем, является ли имя файла числом и находится ли расширение в списке.
        if int(name) and extension.lower() in SUPPORTED_EXTENSIONS and len(name) == 10:
            return True
        return False
    except (ValueError, IndexError):
        # Если int(name) вызывает ошибку, значит, имя не является числом.
        # Если splitext возвращает не 2 элемента, значит, что-то не так с именем файла.
        return False


def generate_new_filename(filename: str, timestamp: int) -> str:
    """
    Формирует новые имя для файла.
    
    Args:
        filename: Оригинальное название файла.
        timestamp: Временная метка для формирования нового названия.
    
    Returns:
        Новое название файла.
    """
    _, extension = os.path.splitext(filename)
    return f"{timestamp}{extension}"
