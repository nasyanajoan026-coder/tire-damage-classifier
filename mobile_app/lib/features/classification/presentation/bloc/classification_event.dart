import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ClassificationEvent extends Equatable {
  const ClassificationEvent();
  @override
  List<Object?> get props => [];
}

class ClassifyImageEvent extends ClassificationEvent {
  final File imageFile;
  const ClassifyImageEvent(this.imageFile);
  @override
  List<Object?> get props => [imageFile];
}

class ResetClassificationEvent extends ClassificationEvent {}