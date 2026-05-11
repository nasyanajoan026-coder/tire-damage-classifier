from flask import Blueprint, request, jsonify, current_app
from app.services.model_service import model_service
from app.services.image_service import ImageService

classification_bp = Blueprint("classification", __name__)

ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png"}


def allowed_file(filename: str) -> bool:
    return (
        "." in filename
        and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS
    )


@classification_bp.route("/classify", methods=["POST"])
def classify():
    # Validasi file ada
    if "image" not in request.files:
        return jsonify({"status": "error", "message": "Tidak ada file image"}), 400

    file = request.files["image"]

    if file.filename == "":
        return jsonify({"status": "error", "message": "File tidak dipilih"}), 400

    if not allowed_file(file.filename):
        return jsonify({
            "status": "error",
            "message": "Format tidak didukung. Gunakan JPG, JPEG, atau PNG"
        }), 400

    try:
        image_bytes = file.read()
        tensor = ImageService.preprocess(image_bytes)

        class_names = current_app.config["CLASS_NAMES"]
        results = model_service.predict_all(tensor, class_names)

        return jsonify({
            "status": "success",
            "data": results
        }), 200

    except Exception as e:
        current_app.logger.error(f"[classify] Error: {e}")
        return jsonify({
            "status": "error",
            "message": "Gagal memproses gambar"
        }), 500