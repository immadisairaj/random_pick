import 'package:dartz/dartz.dart';

import '../../features/random/random_list/domain/entities/item.dart';
import '../../features/random/random_number/domain/entities/number_range.dart';
import '../error/failures.dart';

class InputConverter {
  /// converts the given string [min] and [max] to [NumberRange]
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

  // for now, we assume that all items are selected by default
  /// converts the given strings [itemPool] to [List]<[Item]>
  List<Item> stringsToItemPool(List<String> itemPool) {
    return itemPool.map((item) => Item(text: item)).toList();
  }
}

/// Failure when the input is invalid
class InvalidInputFailure extends Failure {}

/// Failure when the input number range is invalid
class InvalidNumberRangeFailure extends Failure {}
