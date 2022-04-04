import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random_number/data/datasources/random_number_data_source.dart';
import 'package:random_pick/features/random_number/data/models/number_range_model.dart';

void main() {
  late RandomNumberDataSourceImpl dataSource;

  setUp(() {
    dataSource = RandomNumberDataSourceImpl();
  });

  test(
    'should return an integer in the given range',
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
      expect(result, isA<int>());
    },
  );
  test(
    'should return an proper value in the given range',
    () async {
      // arrange
      const tMin = 3;
      const tMax = 4;
      final tNumberRange = NumberRangeModel(min: tMin, max: tMax);
      // act
      final result = await dataSource.getRandomNumber(
        tNumberRange,
      );
      // assert
      expect(result, greaterThanOrEqualTo(tMin));
      expect(result, lessThan(tMax));
    },
  );
}
