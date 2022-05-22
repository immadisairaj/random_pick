import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

/// random number repository which contains the methods for random number
// ignore: one_member_abstracts
abstract class RandomNumberRepository {
  /// returns a random number from the given [numberRange]
  Future<Either<Failure, RandomNumberPicked>> getRandomNumber(
    NumberRange numberRange,
  );
}
