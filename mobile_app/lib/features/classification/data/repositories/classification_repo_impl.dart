import 'dart:io';
import 'package:pdsk_klasifikasi_kerusakan_ban/core/errors/expections.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/image_utils.dart';
import '../../domain/entities/classification_result.dart';
import '../../domain/repositories/classification_repository.dart';
import '../datasources/classification_remote_ds.dart';

class ClassificationRepositoryImpl implements ClassificationRepository {
  final ClassificationRemoteDataSource remoteDataSource;

  const ClassificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<ClassificationResult> classify(File imageFile) async {
    try {
      final compressed = await ImageUtils.compressImage(imageFile);
      return await remoteDataSource.classify(compressed);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}