import 'dart:math';

import '../../data/models/number_range_model.dart';

abstract class RandomNumberDataSource {
  Future<int> getRandomNumber(NumberRangeModel numberRange);
}

class RandomNumberDataSourceImpl implements RandomNumberDataSource {
  @override
  Future<int> getRandomNumber(NumberRangeModel numberRange) {
    int difference = numberRange.max - numberRange.min;
    int randomNumber = Random().nextInt(difference + 1);
    return Future.value(randomNumber + numberRange.min);
  }
}
