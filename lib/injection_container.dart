import 'package:get_it/get_it.dart';

import 'core/utils/input_converter.dart';
import 'features/random/presentation/cubit/random_page_cubit.dart';
import 'features/random/random_list/data/datasources/random_list_data_source.dart';
import 'features/random/random_list/data/repositories/random_list_repository_impl.dart';
import 'features/random/random_list/domain/repositories/random_list_repository.dart';
import 'features/random/random_list/domain/usecases/get_random_item.dart';
import 'features/random/random_list/presentation/bloc/random_list_bloc.dart';
import 'features/random/random_number/data/datasources/random_number_data_source.dart';
import 'features/random/random_number/data/repositories/random_number_repository_impl.dart';
import 'features/random/random_number/domain/repositories/random_number_repository.dart';
import 'features/random/random_number/domain/usecases/get_random_number.dart';
import 'features/random/random_number/presentation/bloc/random_number_bloc.dart';

final getIt = GetIt.instance;

/// Register all the dependencies
void init() {
  // ! Features - Random
  // Cubit
  getIt.registerFactory(
    () => RandomPageCubit(),
  );

  // ! Random Features - Random Number
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

  // ! Random Features - Random List
  // Bloc
  getIt.registerFactory(
    () => RandomListBloc(
      getRandomItem: getIt(),
      inputConverter: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetRandomItem(getIt()));

  // Repository
  getIt.registerLazySingleton<RandomListRepository>(
      () => RandomListRepositoryImpl(dataSource: getIt()));

  // Data sources
  getIt.registerLazySingleton<RandomListDataSource>(
      () => RandomListDataSourceImpl());

  // ! Core
  getIt.registerLazySingleton(() => InputConverter());

  // // ! External
}
