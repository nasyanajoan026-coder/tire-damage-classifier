import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/classify_tire_image.dart';
import '../../../../core/errors/failures.dart';
import 'classification_event.dart';
import 'classification_state.dart';

class ClassificationBloc
    extends Bloc<ClassificationEvent, ClassificationState> {
  final ClassifyTireImage classifyTireImage;

  ClassificationBloc({required this.classifyTireImage})
      : super(ClassificationInitial()) {
    on<ClassifyImageEvent>(_onClassifyImage);
    on<ResetClassificationEvent>(_onReset);
  }

  Future<void> _onClassifyImage(
    ClassifyImageEvent event,
    Emitter<ClassificationState> emit,
  ) async {
    emit(ClassificationLoading());
    try {
      final result = await classifyTireImage.execute(event.imageFile);
      emit(ClassificationSuccess(result));
    } on NetworkFailure catch (e) {
      emit(ClassificationFailure(e.message));
    } on ServerFailure catch (e) {
      emit(ClassificationFailure(e.message));
    } catch (e) {
      emit(ClassificationFailure('Terjadi kesalahan tidak terduga'));
    }
  }

  void _onReset(
    ResetClassificationEvent event,
    Emitter<ClassificationState> emit,
  ) {
    emit(ClassificationInitial());
  }
}