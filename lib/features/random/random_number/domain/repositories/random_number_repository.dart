import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/number_range.dart';
import '../entities/random_number_picked.dart';

/// random number repository which contains the methods for random number
abstract class RandomNumberRepository {
  /// returns a random number from the given [numberRange]
  Future<Either<Failure, RandomNumberPicked>> getRandomNumber(
      NumberRange numberRange);
}
