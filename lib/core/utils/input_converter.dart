import 'package:dartz/dartz.dart';

import '../../features/random/random_list/domain/entities/item.dart';
import '../../features/random/random_number/domain/entities/number_range.dart';
import '../error/failures.dart';

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

  // for now, we assume that all items are selected by default
  List<Item> stringsToItemPool(List<String> itemPool) {
    return itemPool.map((item) => Item(text: item)).toList();
  }
}

class InvalidInputFailure extends Failure {}

class InvalidNumberRangeFailure extends Failure {}
