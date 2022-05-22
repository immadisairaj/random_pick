import 'dart:math';
import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/data/models/random_number_picked_model.dart';

/// data source for random number
// ignore: one_member_abstracts
abstract class RandomNumberDataSource {
  /// return random number from the given [numberRange]
  ///
  /// the main data source of picking a random number
  Future<RandomNumberPickedModel> getRandomNumber(NumberRangeModel numberRange);
}

/// implementation of the [RandomNumberDataSource]
class RandomNumberDataSourceImpl implements RandomNumberDataSource {
  @override
  Future<RandomNumberPickedModel> getRandomNumber(
    NumberRangeModel numberRange,
  ) {
    final difference = numberRange.max - numberRange.min;
    final randomNumber = Random().nextInt(difference + 1);
    return Future.value(
      RandomNumberPickedModel(
        randomNumber: randomNumber + numberRange.min,
        numberRange: numberRange,
      ),
    );
  }
}
