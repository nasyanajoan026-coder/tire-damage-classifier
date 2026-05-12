import 'dart:io';
import '../entities/classification_result.dart';
import '../repositories/classification_repository.dart';

class ClassifyTireImage {
  final ClassificationRepository repository;

  const ClassifyTireImage(this.repository);

  Future<ClassificationResult> execute(File imageFile) {
    return repository.classify(imageFile);
  }
}