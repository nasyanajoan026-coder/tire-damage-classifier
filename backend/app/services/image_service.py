import io
import torch
from PIL import Image
from torchvision import transforms


# Transform identik dengan yang dipakai saat training
INFERENCE_TRANSFORM = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],  # ImageNet mean
        std=[0.229, 0.224, 0.225],   # ImageNet std
    ),
])


class ImageService:
    @staticmethod
    def preprocess(image_bytes: bytes) -> torch.Tensor:
        """
        Terima raw bytes dari upload → return tensor siap predict.
        Shape output: (1, 3, 224, 224)
        """
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        tensor = INFERENCE_TRANSFORM(image)
        return tensor.unsqueeze(0)  # Tambah batch dimension