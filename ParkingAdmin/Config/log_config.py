import sys
from loguru import logger

#from config.config import LEVEL, LOG_ON_FILE, FILENAME, FILE_SIZE
LEVEL="INFO"
LOG_ON_FILE=True
FILENAME="Barrier.log"
FILE_SIZE=10
# Configure the logger with a custom log format
logger.remove()  # Remove the default logger configuration


log_level = LEVEL.upper()
# Configure the logger with console output and custom fields
logger.add(sys.stdout, level=log_level,  colorize=True,
           format="<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | <level>{level: <8}</level> | <yellow>{function}</yellow>:<cyan>{message}</cyan> | <blue>{file}</blue>:<red>{line}</red>")
if LOG_ON_FILE:
    logger.add(f"logs/{FILENAME}", rotation=f"{FILE_SIZE} MB",
               format="{time:YYYY-MM-DD HH:mm:ss.SSS} | {level: <8} | {function}:{message} | {file}:{line}")