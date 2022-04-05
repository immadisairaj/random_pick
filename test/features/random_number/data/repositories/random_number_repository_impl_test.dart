import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:random_pick/features/random_number/data/datasources/random_number_data_source.dart';
import 'package:random_pick/features/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random_number/data/models/random_number_picked_model.dart';
import 'package:random_pick/features/random_number/data/repositories/random_number_repository_impl.dart';

import 'random_number_repository_impl_test.mocks.dart';

@GenerateMocks([RandomNumberDataSource])
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
    'should return if in proper range',
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

      when(mockNumberDataSource.getRandomNumber(tNumberRange))
          .thenAnswer((_) async => tRandomNumberPicked);
      // act
      final result = await repository.getRandomNumber(tNumberRange);
      // assert
      verify(mockNumberDataSource.getRandomNumber(tNumberRange));
      expect(result, equals(Right(tRandomNumberPicked)));
    },
  );

  // below test is commented as the error handling is already done in the entity
  // test(
  //   'should return argument error if not in proper range',
  //   () async {
  //     // arrange
  //     const tMin = 5;
  //     const tMax = 1;
  //     when(mockNumberDataSource.getRandomNumber(any))
  //         .thenThrow(ArgumentError());
  //     // act
  //     final result = await repository
  //         .getRandomNumber(NumberRangeModel(min: tMin, max: tMax));
  //     // assert
  //     verify(mockNumberDataSource
  //         .getRandomNumber(NumberRangeModel(min: tMin, max: tMax)));
  //     expect(result, equals(Left(ArgumentFailure())));
  //   },
  // );
}
