import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret-key")
    DEBUG = False
    TESTING = False

    IMAGE_SIZE = int(os.environ.get("IMAGE_SIZE", 224))
    CLASS_NAMES = os.environ.get("CLASS_NAMES", "good,defective").split(",")

    MOBILENETV2_MODEL_PATH = os.environ.get("MOBILENETV2_MODEL_PATH")
    SHUFFLENETV2_MODEL_PATH = os.environ.get("SHUFFLENETV2_MODEL_PATH")
    EFFICIENTNETB0_MODEL_PATH = os.environ.get("EFFICIENTNETB0_MODEL_PATH")

    ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png"}
    MAX_CONTENT_LENGTH = 10 * 1024 * 1024  # 10MB max upload


class DevelopmentConfig(Config):
    DEBUG = True


class ProductionConfig(Config):
    DEBUG = False


config_map = {
    "development": DevelopmentConfig,
    "production": ProductionConfig,
}

def get_config():
    env = os.environ.get("FLASK_ENV", "development")
    return config_map.get(env, DevelopmentConfig)