import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'core/network/api_client.dart';
import 'features/classification/data/datasources/classification_remote_ds.dart';
import 'features/classification/data/repositories/classification_repo_impl.dart';
import 'features/classification/domain/repositories/classification_repository.dart';
import 'features/classification/domain/usecases/classify_tire_image.dart';
import 'features/classification/presentation/bloc/classification_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => ClassificationBloc(classifyTireImage: sl()));

  // UseCases
  sl.registerLazySingleton(() => ClassifyTireImage(sl()));

  // Repositories
  sl.registerLazySingleton<ClassificationRepository>(
    () => ClassificationRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton(
    () => ClassificationRemoteDataSource(sl()),
  );

  // External
  sl.registerLazySingleton<Dio>(() => ApiClient.instance.dio);
}