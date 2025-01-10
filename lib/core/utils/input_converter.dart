import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';

/// input converter for converting the inputs to desired outputs
class InputConverter {
  /// converts the given string [min] and [max] to [NumberRange]
  Either<Failure, NumberRange> stringsToNumberRange(String min, String max) {
    try {
      final returnMin = int.parse(min);
      final returnMax = int.parse(max);
      return Right(NumberRange(min: returnMin, max: returnMax));
    } on FormatException {
      return Left(InvalidInputFailure());
      // It is fine to catch the error
      // ignore: avoid_catching_errors
    } on ArgumentError {
      return Left(InvalidNumberRangeFailure());
    }
  }
}

/// Failure when the input is invalid
class InvalidInputFailure extends Failure {}

/// Failure when the input number range is invalid
class InvalidNumberRangeFailure extends Failure {}
