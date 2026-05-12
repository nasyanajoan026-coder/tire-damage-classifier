import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pdsk_klasifikasi_kerusakan_ban/core/errors/expections.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/classification_response_model.dart';

class ClassificationRemoteDataSource {
  final Dio dio;

  const ClassificationRemoteDataSource(this.dio);

  Future<ClassificationResponseModel> classify(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'tire_image.jpg',
        ),
      });

      final response = await dio.post(
        ApiConstants.classifyEndpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        return ClassificationResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException('Tidak dapat terhubung ke server');
      }
      throw ServerException(e.message ?? 'Terjadi kesalahan');
    }
  }
}