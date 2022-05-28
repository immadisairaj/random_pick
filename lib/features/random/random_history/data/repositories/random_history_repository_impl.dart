import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/features/random/random_history/data/datasources/random_history_data_source.dart';
import 'package:random_pick/features/random/random_history/data/models/pick_history_model.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/repositories/random_history_repository.dart';

/// Implementation of [RandomHistoryRepository]
class RandomHistoryRepositoryImpl implements RandomHistoryRepository {
  /// constructor for [RandomHistoryRepository] implementation which provides
  /// functions for the use of Random History
  RandomHistoryRepositoryImpl({
    required this.dataSource,
  });

  /// data source from where the data is fetched
  RandomHistoryDataSource dataSource;

  @override
  Future<Either<Failure, Stream<List<PickHistory>>>> getRandomHistory() async {
    final listStream = await dataSource.getRandomHistory();
    return Right(listStream);
  }

  @override
  Future<Either<Failure, void>> putRandomHistory(
    PickHistory pickHistory,
  ) async {
    try {
      return Right(
        await dataSource.addRandomHistory(pickHistory as PickHistoryModel),
      );
    } on HistoryAlreadyExistsException {
      return Left(HistoryAlreadyExistsFailure());
    }
  }

  @override
  Future<Either<Failure, PickHistory>> getRandomHistoryById(String id) async {
    try {
      return Right(await dataSource.getRandomHistoryById(id));
    } on HistoryNotFoundException {
      return Left(HistoryNotFoundFailure());
    }
  }
}

/// history with the same id already exists
class HistoryAlreadyExistsFailure extends Failure {}

/// history does not exist
class HistoryNotFoundFailure extends Failure {}
