import 'dart:math';

import '../../data/models/number_range_model.dart';
import '../../data/models/random_number_picked_model.dart';

abstract class RandomNumberDataSource {
  Future<RandomNumberPickedModel> getRandomNumber(NumberRangeModel numberRange);
}

class RandomNumberDataSourceImpl implements RandomNumberDataSource {
  @override
  Future<RandomNumberPickedModel> getRandomNumber(
      NumberRangeModel numberRange) {
    int difference = numberRange.max - numberRange.min;
    int randomNumber = Random().nextInt(difference + 1);
    return Future.value(RandomNumberPickedModel(
      randomNumber: randomNumber + numberRange.min,
      numberRange: numberRange,
    ));
  }
}
