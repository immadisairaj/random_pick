import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random/random_number/data/datasources/random_number_data_source.dart';
import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/data/models/random_number_picked_model.dart';

void main() {
  late RandomNumberDataSourceImpl dataSource;

  setUp(() {
    dataSource = RandomNumberDataSourceImpl();
  });

  test(
    'should return an RandomNumberPicked in the given range',
    () async {
      // arrange
      const tMin = 1;
      const tMax = 10;
      final tNumberRange = NumberRangeModel(min: tMin, max: tMax);
      // act
      final result = await dataSource.getRandomNumber(
        tNumberRange,
      );
      // assert
      expect(result, isA<RandomNumberPickedModel>());
    },
  );
  test(
    'should return an proper value in the given range',
    () async {
      // arrange
      const tMin = 3;
      const tMax = 3;
      final tNumberRange = NumberRangeModel(min: tMin, max: tMax);
      // act
      final result = await dataSource.getRandomNumber(
        tNumberRange,
      );
      // assert
      expect(result.randomNumber, greaterThanOrEqualTo(tMin));
      expect(result.randomNumber, lessThanOrEqualTo(tMax));
    },
  );
}
