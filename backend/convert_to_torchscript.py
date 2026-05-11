"""
Konversi semua model .pth ke format TorchScript (.ptl)
untuk dipakai di Flutter via PyTorch Mobile.
Jalankan sekali: python convert_to_torchscript.py
"""

import torch
from app.models.mobilenetv2 import MobileNetV2Classifier
from app.models.shufflenetv2 import ShuffleNetV2Classifier
from app.models.efficientnetb0 import EfficientNetB0Classifier

def convert_model(model_class, pth_path: str, output_path: str):
    print(f"Converting {pth_path}...")

    model = model_class(num_classes=2)

    raw = torch.load(pth_path, map_location="cpu", weights_only=True)
    first_key = next(iter(raw.keys()))
    if not first_key.startswith("base_model."):
        raw = {f"base_model.{k}": v for k, v in raw.items()}

    model.load_state_dict(raw, strict=True)
    model.eval()

    # Dummy input untuk trace
    dummy = torch.rand(1, 3, 224, 224)
    traced = torch.jit.trace(model, dummy)

    # Optimize untuk mobile
    from torch.utils.mobile_optimizer import optimize_for_mobile
    optimized = optimize_for_mobile(traced)
    optimized._save_for_lite_interpreter(output_path)

    print(f"✓ Saved: {output_path}")

if __name__ == "__main__":
    convert_model(
        MobileNetV2Classifier,
        "ml_models/mobilenetv2/MobileNetV2_best_model.pth",
        "ml_models/mobilenetv2/mobilenetv2.ptl",
    )
    convert_model(
        ShuffleNetV2Classifier,
        "ml_models/shufflenetv2/ShuffleNetV2_best_model.pth",
        "ml_models/shufflenetv2/shufflenetv2.ptl",
    )
    convert_model(
        EfficientNetB0Classifier,
        "ml_models/efficientnetb0/EfficientNetB0_best_model.pth",
        "ml_models/efficientnetb0/efficientnetb0.ptl",
    )
    print("\nSemua model berhasil dikonversi!")