import 'package:get_it/get_it.dart';
import 'package:random_pick/core/navigation/random_pick_navigation.dart';
import 'package:random_pick/core/utils/input_converter.dart';
import 'package:random_pick/features/random/presentation/cubit/random_page_cubit.dart';
import 'package:random_pick/features/random/random_list/data/datasources/random_list_data_source.dart';
import 'package:random_pick/features/random/random_list/data/repositories/random_list_repository_impl.dart';
import 'package:random_pick/features/random/random_list/domain/repositories/random_list_repository.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/get_random_item.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/subscribe_items.dart';
import 'package:random_pick/features/random/random_list/presentation/bloc/random_list_bloc.dart';
import 'package:random_pick/features/random/random_number/data/datasources/random_number_data_source.dart';
import 'package:random_pick/features/random/random_number/data/repositories/random_number_repository_impl.dart';
import 'package:random_pick/features/random/random_number/domain/repositories/random_number_repository.dart';
import 'package:random_pick/features/random/random_number/domain/usecases/get_random_number.dart';
import 'package:random_pick/features/random/random_number/presentation/bloc/random_number_bloc.dart';

/// get all registered injection containers
final getIt = GetIt.instance;

/// Register all the dependencies
void init() {
  // ! Features - Random
  // Cubit
  getIt
    ..registerFactory(
      RandomPageCubit.new,
    )

    // ! Random Features - Random Number
    // Bloc
    ..registerFactory(
      () => RandomNumberBloc(
        getRandomNumber: getIt(),
        inputConverter: getIt(),
      ),
    )

    // Use cases
    ..registerLazySingleton(() => GetRandomNumber(getIt()))

    // Repository
    ..registerLazySingleton<RandomNumberRepository>(
      () => RandomNumberRepositoryImpl(dataSource: getIt()),
    )

    // Data sources
    ..registerLazySingleton<RandomNumberDataSource>(
      RandomNumberDataSourceImpl.new,
    )

    // ! Random Features - Random List
    // Bloc
    ..registerFactory(
      () => RandomListBloc(
        getRandomItem: getIt(),
        subscribeItems: getIt(),
      ),
    )

    // Use cases
    ..registerLazySingleton(() => GetRandomItem(getIt()))
    ..registerLazySingleton(() => SubscribeItems(getIt()))

    // Repository
    ..registerLazySingleton<RandomListRepository>(
      () => RandomListRepositoryImpl(dataSource: getIt()),
    )

    // Data sources
    ..registerLazySingleton<RandomListDataSource>(RandomListDataSourceImpl.new)

    // ! Core
    ..registerLazySingleton(InputConverter.new)
    ..registerLazySingleton(RandomPickNavigation.new);

  // // ! External
}
