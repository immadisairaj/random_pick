import 'package:dartz/dartz.dart';

import '../error/failures.dart';
import '../../features/random/random_number/domain/entities/number_range.dart';

class InputConverter {
  Either<Failure, NumberRange> stringsToNumberRange(String min, String max) {
    try {
      final returnMin = int.parse(min);
      final returnMax = int.parse(max);
      return Right(NumberRange(min: returnMin, max: returnMax));
    } on FormatException {
      return Left(InvalidInputFailure());
    } on ArgumentError {
      return Left(InvalidNumberRangeFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}

class InvalidNumberRangeFailure extends Failure {}
