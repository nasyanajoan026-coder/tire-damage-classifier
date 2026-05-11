import os
import time
import torch
import torch.nn.functional as F
from flask import current_app

from app.models import (
    MobileNetV2Classifier,
    ShuffleNetV2Classifier,
    EfficientNetB0Classifier,
)


class ModelService:
    _instance = None
    _models: dict = {}
    _device: torch.device = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def init_app(self, app):
        self._device = torch.device(
            "cuda" if torch.cuda.is_available() else "cpu"
        )
        app.logger.info(f"[ModelService] Menggunakan device: {self._device}")

        model_configs = {
            "mobilenetv2": {
                "class": MobileNetV2Classifier,
                "path": app.config["MOBILENETV2_MODEL_PATH"],
            },
            "shufflenetv2": {
                "class": ShuffleNetV2Classifier,
                "path": app.config["SHUFFLENETV2_MODEL_PATH"],
            },
            "efficientnetb0": {
                "class": EfficientNetB0Classifier,
                "path": app.config["EFFICIENTNETB0_MODEL_PATH"],
            },
        }

        for name, cfg in model_configs.items():
            try:
                model = cfg["class"](num_classes=2)

                # Load raw state dict dari file .pth
                raw_state_dict = torch.load(
                    cfg["path"],
                    map_location=self._device,
                    weights_only=True,
                )

                # Cek apakah file .pth punya prefix "base_model." atau tidak
                first_key = next(iter(raw_state_dict.keys()))

                if not first_key.startswith("base_model."):
                    # File .pth TIDAK punya prefix, tapi class kita pakai prefix
                    # → tambahkan prefix "base_model." ke semua key
                    remapped = {
                        f"base_model.{k}": v
                        for k, v in raw_state_dict.items()
                    }
                else:
                    remapped = raw_state_dict

                model.load_state_dict(remapped, strict=True)
                model.to(self._device)
                model.eval()
                self._models[name] = model
                app.logger.info(f"[ModelService] ✓ {name} loaded")

            except Exception as e:
                app.logger.error(f"[ModelService] ✗ Gagal load {name}: {e}")

    def predict_all(self, tensor: torch.Tensor, class_names: list) -> dict:
        tensor = tensor.to(self._device)
        results = {}

        for name, model in self._models.items():
            start = time.time()
            with torch.no_grad():
                output = model(tensor)
                probabilities = F.softmax(output, dim=1)
                confidence, predicted = torch.max(probabilities, 1)

            elapsed_ms = round((time.time() - start) * 1000, 2)
            pred_idx = predicted.item()

            results[name] = {
                "label": class_names[pred_idx],
                "confidence": round(confidence.item() * 100, 2),
                "probabilities": {
                    class_names[i]: round(probabilities[0][i].item() * 100, 2)
                    for i in range(len(class_names))
                },
                "inference_time_ms": elapsed_ms,
            }

        best_model = max(results, key=lambda k: results[k]["confidence"])
        results["best_model"] = best_model

        return results


model_service = ModelService()