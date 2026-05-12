import 'package:equatable/equatable.dart';
import '../../domain/entities/classification_result.dart';

abstract class ClassificationState extends Equatable {
  const ClassificationState();
  @override
  List<Object?> get props => [];
}

class ClassificationInitial extends ClassificationState {}

class ClassificationLoading extends ClassificationState {}

class ClassificationSuccess extends ClassificationState {
  final ClassificationResult result;
  const ClassificationSuccess(this.result);
  @override
  List<Object?> get props => [result];
}

class ClassificationFailure extends ClassificationState {
  final String message;
  const ClassificationFailure(this.message);
  @override
  List<Object?> get props => [message];
}