import torch
import torch.nn as nn
from torchvision import models


class MobileNetV2Classifier(nn.Module):
    """
    MobileNetV2 binary classifier.
    Arsitektur harus IDENTIK dengan yang dipakai saat training.
    Output: 2 kelas (good, defective)
    """

    def __init__(self, num_classes: int = 2):
        super(MobileNetV2Classifier, self).__init__()
        # Load arsitektur MobileNetV2 tanpa pretrained weights
        self.base_model = models.mobilenet_v2(weights=None)
        # Ganti classifier head sesuai jumlah kelas
        in_features = self.base_model.classifier[1].in_features
        self.base_model.classifier = nn.Sequential(
            nn.Dropout(p=0.2, inplace=False),
            nn.Linear(in_features, num_classes),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.base_model(x)