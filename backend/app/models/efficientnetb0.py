import torch
import torch.nn as nn
from torchvision import models


class EfficientNetB0Classifier(nn.Module):
    """
    EfficientNetB0 binary classifier.
    Output: 2 kelas (good, defective)
    """

    def __init__(self, num_classes: int = 2):
        super(EfficientNetB0Classifier, self).__init__()
        self.base_model = models.efficientnet_b0(weights=None)
        in_features = self.base_model.classifier[1].in_features
        self.base_model.classifier = nn.Sequential(
            nn.Dropout(p=0.2, inplace=False),
            nn.Linear(in_features, num_classes),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.base_model(x)