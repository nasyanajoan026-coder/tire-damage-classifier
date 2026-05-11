import torch
import torch.nn as nn
from torchvision import models


class ShuffleNetV2Classifier(nn.Module):
    def __init__(self, num_classes: int = 2):
        super(ShuffleNetV2Classifier, self).__init__()
        self.base_model = models.shufflenet_v2_x1_0(weights=None)
        in_features = self.base_model.fc.in_features

        # Pakai Sequential dengan index 1 supaya key-nya fc.1.weight
        # sesuai dengan yang tersimpan di file .pth
        self.base_model.fc = nn.Sequential(
            nn.Dropout(p=0.2),
            nn.Linear(in_features, num_classes),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.base_model(x)