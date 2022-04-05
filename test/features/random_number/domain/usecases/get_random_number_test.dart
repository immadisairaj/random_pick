import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:random_pick/features/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random_number/domain/entities/random_number_picked.dart';
import 'package:random_pick/features/random_number/domain/repositories/random_number_repository.dart';
import 'package:random_pick/features/random_number/domain/usecases/get_random_number.dart';

import 'get_random_number_test.mocks.dart';

@GenerateMocks([RandomNumberRepository])
void main() {
  late GetRandomNumber usecase;
  late RandomNumberRepository mockNumberRangeRepository;

  setUp(() {
    mockNumberRangeRepository = MockRandomNumberRepository();
    usecase = GetRandomNumber(mockNumberRangeRepository);
  });

  final tNumberRange = NumberRange(min: 1, max: 10);
  final tRandomNumberPicked = RandomNumberPicked(
    randomNumber: 3,
    numberRange: tNumberRange,
  );

  test(
    'should get random number picked from repository',
    () async {
      // arrange
      when(mockNumberRangeRepository.getRandomNumber(tNumberRange))
          .thenAnswer((_) async => Right(tRandomNumberPicked));
      // act
      final result = await usecase(Params(numberRange: tNumberRange));
      // assert
      expect(result, Right(tRandomNumberPicked));
      verify(mockNumberRangeRepository.getRandomNumber(tNumberRange));
      verifyNoMoreInteractions(mockNumberRangeRepository);
    },
  );
}
