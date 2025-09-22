import os

# Список поддерживаемых расширений изображений.
# Используем нижний регистр для единообразия.
SUPPORTED_EXTENSIONS: set = {
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp'
}
LENGTH_UNIX_TIME: int = 10


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
        # Проверяем, является ли имя файла числом, имеет ли правильную длину
        # и находится ли расширение в списке.
        if (
            name.isdigit() # Проверяем, что строка состоит только из цифр
            and len(name) == LENGTH_UNIX_TIME
            and extension.lower() in SUPPORTED_EXTENSIONS
        ):
            return True
        return False
    except (ValueError, IndexError):
        # Эта часть кода уже не сработает из-за name.isdigit(), но лучше оставить,
        # так как она по-прежнему полезна
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
