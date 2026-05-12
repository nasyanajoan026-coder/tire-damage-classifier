class AppConstants {
  static const String appName = 'Tire Damage Classifier';
  static const int imageSize = 224;
  static const List<String> modelNames = [
    'mobilenetv2',
    'shufflenetv2',
    'efficientnetb0',
  ];
  static const Map<String, String> modelDisplayNames = {
    'mobilenetv2': 'MobileNetV2',
    'shufflenetv2': 'ShuffleNetV2',
    'efficientnetb0': 'EfficientNetB0',
  };
}