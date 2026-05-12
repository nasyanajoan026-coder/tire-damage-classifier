import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:5000/api/v1';

  static String get classifyEndpoint => '$baseUrl/classify';
  static String get healthEndpoint => '$baseUrl/health';
}