import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';

/// random history repository which contains the methods for random history
abstract class RandomHistoryRepository {
  /// returns the all random history
  Future<Either<Failure, Stream<List<PickHistory>>>> getRandomHistory();

  /// returns the random history of the given id
  Future<Either<Failure, PickHistory>> getRandomHistoryById(String id);

  /// puts the given [pickHistory] in the database
  Future<Either<Failure, void>> putRandomHistory(PickHistory pickHistory);
}
