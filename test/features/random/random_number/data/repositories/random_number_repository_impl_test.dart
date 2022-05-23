import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/features/random/random_number/data/datasources/random_number_data_source.dart';
import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/data/models/random_number_picked_model.dart';
import 'package:random_pick/features/random/random_number/data/repositories/random_number_repository_impl.dart';

class MockRandomNumberDataSource extends Mock
    implements RandomNumberDataSource {}

void main() {
  late RandomNumberRepositoryImpl repository;
  late MockRandomNumberDataSource mockNumberDataSource;

  setUp(() {
    mockNumberDataSource = MockRandomNumberDataSource();
    repository = RandomNumberRepositoryImpl(
      dataSource: mockNumberDataSource,
    );
  });

  test(
    'should return if picked properly',
    () async {
      // arrange
      const tMin = 1;
      const tMax = 10;
      final tNumberRange = NumberRangeModel(min: tMin, max: tMax);
      const tRandomNumber = 5;
      final tRandomNumberPicked = RandomNumberPickedModel(
        randomNumber: tRandomNumber,
        numberRange: tNumberRange,
      );

      when(() => mockNumberDataSource.getRandomNumber(tNumberRange))
          .thenAnswer((_) async => tRandomNumberPicked);
      // act
      final result = await repository.getRandomNumber(tNumberRange);
      // assert
      verify(() => mockNumberDataSource.getRandomNumber(tNumberRange));
      expect(
        result,
        equals(
          Right<dynamic, RandomNumberPickedModel>(tRandomNumberPicked),
        ),
      );
    },
  );
}
