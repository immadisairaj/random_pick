import 'package:get_it/get_it.dart';

import 'core/utils/input_converter.dart';
import 'features/random/random_number/data/datasources/random_number_data_source.dart';
import 'features/random/random_number/data/repositories/random_number_repository_impl.dart';
import 'features/random/random_number/domain/repositories/random_number_repository.dart';
import 'features/random/random_number/domain/usecases/get_random_number.dart';
import 'features/random/random_number/presentation/bloc/random_number_bloc.dart';

final getIt = GetIt.instance;

void init() {
  // ! Features - Number Range
  // Bloc
  getIt.registerFactory(
    () => RandomNumberBloc(
      getRandomNumber: getIt(),
      inputConverter: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetRandomNumber(getIt()));

  // Repository
  getIt.registerLazySingleton<RandomNumberRepository>(
      () => RandomNumberRepositoryImpl(dataSource: getIt()));

  // Data sources
  getIt.registerLazySingleton<RandomNumberDataSource>(
      () => RandomNumberDataSourceImpl());

  // ! Core
  getIt.registerLazySingleton(() => InputConverter());

  // // ! External
}
