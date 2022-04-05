import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_pick/core/utils/input_converter.dart';
import 'package:random_pick/features/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random_number/domain/entities/random_number_picked.dart';
import 'package:random_pick/features/random_number/domain/usecases/get_random_number.dart';
import 'package:random_pick/features/random_number/presentation/bloc/random_number_bloc.dart';

import 'random_number_bloc_test.mocks.dart';

@GenerateMocks([GetRandomNumber, InputConverter])
void main() {
  late RandomNumberBloc bloc;
  late MockGetRandomNumber mockGetRandomNumber;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomNumber = MockGetRandomNumber();
    mockInputConverter = MockInputConverter();
    bloc = RandomNumberBloc(
      getRandomNumber: mockGetRandomNumber,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be RandomNumberEmpty', () {
    expect(bloc.state, equals(RandomNumberEmpty()));
  });

  group('get random number for number range', () {
    const String tMinString = '9';
    const String tMaxString = '10';
    const int tMinInt = 9;
    const int tMaxInt = 10;
    final NumberRange tNumberRange = NumberRange(min: tMinInt, max: tMaxInt);
    const int tRandomNumber = 9;
    final RandomNumberPicked tRandomNumberPicked = RandomNumberPicked(
        randomNumber: tRandomNumber, numberRange: tNumberRange);

    test('should emit [Error] state when no proper input', () {
      // arrage
      when(mockInputConverter.stringsToNumberRange(any, any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        // RandomNumberEmpty(),
        const RandomNumberError(errorMessage: invalidInputError),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetRandomNumberForRange(
        min: tMinString,
        max: tMaxString,
      ));
    });

    test('should emit [Error] state when no proper input range', () {
      // arrage
      when(mockInputConverter.stringsToNumberRange(any, any))
          .thenReturn(Left(InvalidNumberRangeFailure()));
      // assert later
      final expected = [
        // RandomNumberEmpty(),
        const RandomNumberError(errorMessage: invalidNumberRangeError),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetRandomNumberForRange(
        min: tMaxString,
        max: tMinString,
      ));
    });

    setUpMockInputSuccess() {
      when(mockInputConverter.stringsToNumberRange(any, any))
          .thenReturn(Right(tNumberRange));
    }

    test(
      'should call input converter validate and convert strings to NumberRange'
      'and get random number from the usecase',
      () async {
        // arrange
        setUpMockInputSuccess();
        when(mockGetRandomNumber(any))
            .thenAnswer((_) async => Right(tRandomNumberPicked));
        // act
        bloc.add(const GetRandomNumberForRange(
          min: tMinString,
          max: tMaxString,
        ));
        await untilCalled(mockInputConverter.stringsToNumberRange(any, any));
        await untilCalled(mockGetRandomNumber(any));
        // assert
        verify(mockInputConverter.stringsToNumberRange(tMinString, tMaxString));
        verify(mockGetRandomNumber(Params(numberRange: tNumberRange)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputSuccess();
        when(mockGetRandomNumber(any))
            .thenAnswer((_) async => Right(tRandomNumberPicked));
        // assert later
        final expected = [
          // RandomNumberEmpty(),
          RandomNumberLoading(),
          RandomNumberLoaded(randomNumberPicked: tRandomNumberPicked),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomNumberForRange(
          min: tMinString,
          max: tMaxString,
        ));
      },
    );
  });
}
