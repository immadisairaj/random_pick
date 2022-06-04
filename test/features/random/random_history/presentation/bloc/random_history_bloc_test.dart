import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_history/data/repositories/random_history_repository_impl.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/usecases/subscribe_random_history.dart';
import 'package:random_pick/features/random/random_history/presentation/bloc/random_history_bloc.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';
import 'package:rxdart/subjects.dart';

class MockSubscribeRandomHistory extends Mock
    implements SubscribeRandomHistory {}

void main() {
  late RandomHistoryBloc bloc;
  late MockSubscribeRandomHistory mockSubscribeRandomHistory;

  setUp(() {
    mockSubscribeRandomHistory = MockSubscribeRandomHistory();
    bloc = RandomHistoryBloc(
      subscribeRandomHistory: mockSubscribeRandomHistory,
    );
  });

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const IdParams(id: 'test'));
    registerFallbackValue(
      HistoryParams(
        pickHistory: PickHistory(
          dateTime: DateTime.now(),
          picked: RandomNumberPicked(
            randomNumber: 0,
            numberRange: NumberRange(max: 0),
          ),
        ),
        index: 0,
      ),
    );
  });

  void returnVoid() {
    return;
  }

  const tRandomHistoryState = RandomHistoryState();

  test('initial state should be RandomHistory with default status', () {
    expect(bloc.state, equals(const RandomHistoryState()));
  });

  group('subscribe history', () {
    final tHistoryList = <PickHistory>[
      PickHistory(
        dateTime: DateTime.now(),
        picked: RandomNumberPicked(
          randomNumber: 0,
          numberRange: NumberRange(max: 0),
        ),
      ),
    ];

    test(
      'should load and subscribe items',
      () {
        // arrange
        final tController = BehaviorSubject<List<PickHistory>>.seeded(const []);
        final tStream = tController.asBroadcastStream();
        when(() => mockSubscribeRandomHistory(any()))
            .thenAnswer((_) async => Right(tStream));
        // assert later
        final expected = [
          tRandomHistoryState.copyWith(
            status: () => RandomHistoryStatus.loading,
          ),
          tRandomHistoryState.copyWith(
            status: () => RandomHistoryStatus.loaded,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const HistorySubscriptionRequested());
      },
    );

    test(
      'should fail when subscribe items',
      () {
        // arrange
        when(() => mockSubscribeRandomHistory(any()))
            .thenAnswer((_) async => const Left(UnknownFailure()));
        // assert later
        final expected = [
          tRandomHistoryState.copyWith(
            status: () => RandomHistoryStatus.loading,
          ),
          tRandomHistoryState.copyWith(
            status: () => RandomHistoryStatus.error,
            errorMessage: () => 'Unexpected error',
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const HistorySubscriptionRequested());
      },
    );

    test(
      'should fail when subscribe items in right',
      () {
        // arrange
        final tController = BehaviorSubject<List<PickHistory>>.seeded(const [])
          // add error to stream
          ..addError(const UnknownFailure());
        final tStream = tController.asBroadcastStream();
        when(() => mockSubscribeRandomHistory(any()))
            .thenAnswer((_) async => Right(tStream));
        // assert later
        final expected = [
          tRandomHistoryState.copyWith(
            status: () => RandomHistoryStatus.loading,
          ),
          tRandomHistoryState.copyWith(
            status: () => RandomHistoryStatus.error,
            errorMessage: () => 'Unexpected error',
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const HistorySubscriptionRequested());
      },
    );

    test(
      'should not emit on pick history added',
      () {
        // arrange
        when(
          () => mockSubscribeRandomHistory
              .putRandomHistory(HistoryParams(pickHistory: tHistoryList[0])),
        ).thenAnswer((_) async => Right(returnVoid()));
        // assert later
        final expected = <dynamic>[];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(HistoryAddRequested(pickHistory: tHistoryList[0]));
      },
    );

    test(
      'should fail on pick history added',
      () {
        // arrange
        when(
          () => mockSubscribeRandomHistory
              .putRandomHistory(HistoryParams(pickHistory: tHistoryList[0])),
        ).thenAnswer((_) async => Left(HistoryAlreadyExistsFailure()));
        // assert later
        final expected = <dynamic>[
          tRandomHistoryState.copyWith(
            status: () => RandomHistoryStatus.error,
            errorMessage: () => historyAlreadyExists,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(HistoryAddRequested(pickHistory: tHistoryList[0]));
      },
    );

    test('should not emit on clearAllHistory', () {
      // arrange
      when(
        () => mockSubscribeRandomHistory.clearAllHistory(any()),
      ).thenAnswer((_) async => Right(returnVoid()));
      // assert later
      final expected = <dynamic>[];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ClearAllHistoryRequested());
    });

    test('should fail on clearAllHistory', () {
      // arrange
      when(
        () => mockSubscribeRandomHistory.clearAllHistory(any()),
      ).thenAnswer((_) async => const Left(UnknownFailure()));
      // assert later
      final expected = <dynamic>[
        tRandomHistoryState.copyWith(
          status: () => RandomHistoryStatus.error,
          errorMessage: () => 'Unexpected error',
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ClearAllHistoryRequested());
    });

    test('should not emit on clearHistory', () {
      // arrange
      when(
        () => mockSubscribeRandomHistory.clearHistory(any()),
      ).thenAnswer((_) async => Right(returnVoid()));
      // assert later
      final expected = <dynamic>[];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(ClearHistoryRequested(pickHistory: tHistoryList[0]));
    });

    test('should emit on clearHistory when index is specified', () {
      // arrange
      when(
        () => mockSubscribeRandomHistory.clearHistory(any()),
      ).thenAnswer((_) async => Right(returnVoid()));
      // assert later
      final expected = <dynamic>[
        tRandomHistoryState.copyWith(
          lastDeletedHistory: () =>
              DeletedHistory(index: 0, pickHistory: tHistoryList[0]),
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(ClearHistoryRequested(pickHistory: tHistoryList[0], index: 0));
    });

    test('should fail HistoryNotFoundFailure when clearHistory', () {
      // arrange
      when(
        () => mockSubscribeRandomHistory.clearHistory(any()),
      ).thenAnswer((_) async => Left(HistoryNotFoundFailure()));
      // assert later
      final expected = <dynamic>[
        tRandomHistoryState.copyWith(
          status: () => RandomHistoryStatus.error,
          errorMessage: () => historyNotFoundError,
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(ClearHistoryRequested(pickHistory: tHistoryList[0]));
    });

    test('should emit on clearHistoryUndo when lastDeleted is not null', () {
      // arrange
      when(
        () => mockSubscribeRandomHistory.clearHistory(any()),
      ).thenAnswer((_) async => Right(returnVoid()));
      when(
        () => mockSubscribeRandomHistory.putRandomHistory(any()),
      ).thenAnswer((_) async => Right(returnVoid()));
      // assert later
      final expected = <dynamic>[
        tRandomHistoryState.copyWith(
          lastDeletedHistory: () =>
              DeletedHistory(index: 0, pickHistory: tHistoryList[0]),
        ),
        tRandomHistoryState.copyWith(
          lastDeletedHistory: () => null,
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc
        ..add(ClearHistoryRequested(pickHistory: tHistoryList[0], index: 0))
        ..add(const ClearHistoryUndoRequested());
    });

    test('should fail clearHistoryUndo when lastDeleted', () {
      // arrange
      when(
        () => mockSubscribeRandomHistory.clearHistory(any()),
      ).thenAnswer((_) async => Right(returnVoid()));
      when(
        () => mockSubscribeRandomHistory.putRandomHistory(any()),
      ).thenAnswer((_) async => const Left(UnknownFailure()));
      // assert later
      final expected = <dynamic>[
        tRandomHistoryState.copyWith(
          lastDeletedHistory: () =>
              DeletedHistory(index: 0, pickHistory: tHistoryList[0]),
        ),
        tRandomHistoryState.copyWith(
          status: () => RandomHistoryStatus.error,
          errorMessage: () => 'Unexpected error',
          lastDeletedHistory: () => null,
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc
        ..add(ClearHistoryRequested(pickHistory: tHistoryList[0], index: 0))
        ..add(const ClearHistoryUndoRequested());
    });
  });
}
