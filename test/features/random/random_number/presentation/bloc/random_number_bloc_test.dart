import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/utils/input_converter.dart';
import 'package:random_pick/features/random/random_history/data/repositories/random_history_repository_impl.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/usecases/subscribe_random_history.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';
import 'package:random_pick/features/random/random_number/domain/usecases/get_random_number.dart';
import 'package:random_pick/features/random/random_number/presentation/bloc/random_number_bloc.dart';

class MockGetRandomNumber extends Mock implements GetRandomNumber {}

class MockInputConverter extends Mock implements InputConverter {}

class MockSubscribeRandomHistory extends Mock
    implements SubscribeRandomHistory {}

void main() {
  late RandomNumberBloc bloc;
  late MockGetRandomNumber mockGetRandomNumber;
  late MockInputConverter mockInputConverter;
  late MockSubscribeRandomHistory mockSubscribeRandomHistory;

  setUp(() {
    mockGetRandomNumber = MockGetRandomNumber();
    mockInputConverter = MockInputConverter();
    mockSubscribeRandomHistory = MockSubscribeRandomHistory();
    bloc = RandomNumberBloc(
      getRandomNumber: mockGetRandomNumber,
      inputConverter: mockInputConverter,
      subscribeRandomHistory: mockSubscribeRandomHistory,
    );
  });

  setUpAll(() {
    registerFallbackValue(Params(numberRange: NumberRange(max: 1)));
  });

  test('initial state should be RandomNumberEmpty', () {
    expect(bloc.state, equals(RandomNumberEmpty()));
  });

  group('get random number for number range', () {
    const tMinString = '9';
    const tMaxString = '10';
    const tMinInt = 9;
    const tMaxInt = 10;
    final tNumberRange = NumberRange(min: tMinInt, max: tMaxInt);
    const tRandomNumber = 9;
    final tRandomNumberPicked = RandomNumberPicked(
      randomNumber: tRandomNumber,
      numberRange: tNumberRange,
    );
    final tRandomPickHistory = PickHistory(
      dateTime: DateTime.now(),
      picked: tRandomNumberPicked,
    );

    test('should emit [Error] state when no proper input', () {
      // arrage
      when(() => mockInputConverter.stringsToNumberRange(any(), any()))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        // RandomNumberEmpty(),
        const RandomNumberError(errorMessage: invalidInputError),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
        const GetRandomNumberForRange(
          min: tMinString,
          max: tMaxString,
        ),
      );
    });

    test('should emit [Error] state when no proper input range', () {
      // arrage
      when(() => mockInputConverter.stringsToNumberRange(any(), any()))
          .thenReturn(Left(InvalidNumberRangeFailure()));
      // assert later
      final expected = [
        // RandomNumberEmpty(),
        const RandomNumberError(errorMessage: invalidNumberRangeError),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
        const GetRandomNumberForRange(
          min: tMaxString,
          max: tMinString,
        ),
      );
    });

    void setUpMockInputSuccess() {
      when(() => mockInputConverter.stringsToNumberRange(any(), any()))
          .thenReturn(Right(tNumberRange));
    }

    void returnVoid() {
      return;
    }

    setUpAll(() {
      registerFallbackValue(HistoryParams(pickHistory: tRandomPickHistory));
    });

    void setUpMockHistorySuccess() {
      when(() => mockSubscribeRandomHistory.putRandomHistory(any()))
          .thenAnswer((_) async => Right(returnVoid()));
    }

    test(
      // ignore: missing_whitespace_between_adjacent_strings
      'should call input converter validate and convert strings to NumberRange'
      'and get random number from the usecase',
      () async {
        // arrange
        setUpMockInputSuccess();
        setUpMockHistorySuccess();
        when(() => mockGetRandomNumber(any()))
            .thenAnswer((_) async => Right(tRandomNumberPicked));
        // act
        bloc.add(
          const GetRandomNumberForRange(
            min: tMinString,
            max: tMaxString,
          ),
        );
        await untilCalled(
          () => mockInputConverter.stringsToNumberRange(any(), any()),
        );
        // await untilCalled(() => mockGetRandomNumber(any()));
        await untilCalled(
          () => mockSubscribeRandomHistory.putRandomHistory(any()),
        );
        // assert
        verify(
          () => mockInputConverter.stringsToNumberRange(tMinString, tMaxString),
        );
        verify(() => mockGetRandomNumber(Params(numberRange: tNumberRange)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () {
        // arrange
        setUpMockInputSuccess();
        setUpMockHistorySuccess();
        when(() => mockGetRandomNumber(any()))
            .thenAnswer((_) async => Right(tRandomNumberPicked));
        // assert later
        final expected = [
          // RandomNumberEmpty(),
          RandomNumberLoading(),
          RandomNumberLoaded(randomNumberPicked: tRandomNumberPicked),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          const GetRandomNumberForRange(
            min: tMinString,
            max: tMaxString,
          ),
        );
      },
    );

    test(
      'should emit [Loading, Error] when data is not gotten successfully',
      () {
        // arrange
        setUpMockInputSuccess();
        setUpMockHistorySuccess();
        when(() => mockGetRandomNumber(any()))
            .thenAnswer((_) async => const Left(UnknownFailure()));
        // assert later
        final expected = [
          // RandomNumberEmpty(),
          RandomNumberLoading(),
          const RandomNumberError(errorMessage: 'Unexpected error'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          const GetRandomNumberForRange(
            min: tMinString,
            max: tMaxString,
          ),
        );
      },
    );

    test(
      // ignore: missing_whitespace_between_adjacent_strings
      'should emit [Loading, Error] when data is gotten successfully'
      'but, the history is not saved',
      () {
        // arrange
        setUpMockInputSuccess();
        when(() => mockGetRandomNumber(any()))
            .thenAnswer((_) async => Right(tRandomNumberPicked));
        when(() => mockSubscribeRandomHistory.putRandomHistory(any()))
            .thenAnswer((_) async => Left(HistoryAlreadyExistsFailure()));
        // assert later
        final expected = [
          // RandomNumberEmpty(),
          RandomNumberLoading(),
          const RandomNumberError(errorMessage: historyAlreadyExists),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(
          const GetRandomNumberForRange(
            min: tMinString,
            max: tMaxString,
          ),
        );
      },
    );
  });
}
