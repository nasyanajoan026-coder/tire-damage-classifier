import 'dart:io';
import '../entities/classification_result.dart';

abstract class ClassificationRepository {
  Future<ClassificationResult> classify(File imageFile);
}