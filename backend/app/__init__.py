from flask import Flask
from flask_cors import CORS
from app.config import get_config
from app.services.model_service import model_service


def create_app():
    app = Flask(__name__)
    app.config.from_object(get_config())

    # CORS supaya Flutter bisa akses
    CORS(app)

    # Load semua model saat startup
    model_service.init_app(app)

    # Register routes
    from app.api.v1.health import health_bp
    from app.api.v1.classification import classification_bp

    app.register_blueprint(health_bp, url_prefix="/api/v1")
    app.register_blueprint(classification_bp, url_prefix="/api/v1")

    return app