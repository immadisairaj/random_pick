import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_range.dart';

/// number range repository
abstract class RandomNumberRepository {
  /// returns a random number from the given [numberRange]
  Future<Either<Failure, int>> getRandomNumber(NumberRange numberRange);
}
