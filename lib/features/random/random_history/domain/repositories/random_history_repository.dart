import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';

/// random history repository which contains the methods for random history
abstract class RandomHistoryRepository {
  /// returns the all random history
  Future<Either<Failure, Stream<List<PickHistory>>>> getRandomHistory();

  /// returns the random history of the given id
  Future<Either<Failure, PickHistory>> getRandomHistoryById(String id);

  /// puts the given [pickHistory] in the database;
  /// if [index] is specified, it will be put in the given index
  Future<Either<Failure, void>> putRandomHistory(
    PickHistory pickHistory, {
    int? index,
  });

  /// deletes the random history of the given [pickHistory]
  Future<Either<Failure, void>> clearHistory(PickHistory pickHistory);

  /// deletes all the random history
  Future<Either<Failure, void>> clearAllHistory();
}
