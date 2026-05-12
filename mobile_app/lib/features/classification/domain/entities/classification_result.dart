class ModelResult {
  final String label;
  final double confidence;
  final Map<String, double> probabilities;
  final double inferenceTimeMs;

  const ModelResult({
    required this.label,
    required this.confidence,
    required this.probabilities,
    required this.inferenceTimeMs,
  });

  bool get isDefective => label.toLowerCase() == 'defective';
}

class ClassificationResult {
  final ModelResult mobilenetv2;
  final ModelResult shufflenetv2;
  final ModelResult efficientnetb0;
  final String bestModel;
  final DateTime timestamp;

  const ClassificationResult({
    required this.mobilenetv2,
    required this.shufflenetv2,
    required this.efficientnetb0,
    required this.bestModel,
    required this.timestamp,
  });

  ModelResult get bestModelResult {
    switch (bestModel) {
      case 'shufflenetv2':
        return shufflenetv2;
      case 'efficientnetb0':
        return efficientnetb0;
      default:
        return mobilenetv2;
    }
  }

  Map<String, ModelResult> get allResults => {
        'mobilenetv2': mobilenetv2,
        'shufflenetv2': shufflenetv2,
        'efficientnetb0': efficientnetb0,
      };
}