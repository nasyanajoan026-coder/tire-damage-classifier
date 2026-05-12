import '../../domain/entities/classification_result.dart';

class ModelResultModel extends ModelResult {
  const ModelResultModel({
    required super.label,
    required super.confidence,
    required super.probabilities,
    required super.inferenceTimeMs,
  });

  factory ModelResultModel.fromJson(Map<String, dynamic> json) {
    final probs = (json['probabilities'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, (v as num).toDouble()),
    );
    return ModelResultModel(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      probabilities: probs,
      inferenceTimeMs: (json['inference_time_ms'] as num).toDouble(),
    );
  }
}

class ClassificationResponseModel extends ClassificationResult {
  const ClassificationResponseModel({
    required super.mobilenetv2,
    required super.shufflenetv2,
    required super.efficientnetb0,
    required super.bestModel,
    required super.timestamp,
  });

  factory ClassificationResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ClassificationResponseModel(
      mobilenetv2: ModelResultModel.fromJson(
          data['mobilenetv2'] as Map<String, dynamic>),
      shufflenetv2: ModelResultModel.fromJson(
          data['shufflenetv2'] as Map<String, dynamic>),
      efficientnetb0: ModelResultModel.fromJson(
          data['efficientnetb0'] as Map<String, dynamic>),
      bestModel: data['best_model'] as String,
      timestamp: DateTime.now(),
    );
  }
}