import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/repositories/random_history_repository.dart';
import 'package:random_pick/features/random/random_history/domain/usecases/subscribe_random_history.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';

class MockRandomHistoryRepository extends Mock
    implements RandomHistoryRepository {}

void main() {
  late SubscribeRandomHistory usecase;
  late MockRandomHistoryRepository mockRandomHistoryRepository;

  setUp(() {
    mockRandomHistoryRepository = MockRandomHistoryRepository();
    usecase = SubscribeRandomHistory(mockRandomHistoryRepository);
  });

  final tController = StreamController<List<PickHistory>>();
  final tStream = tController.stream;
  final tItemPool = [
    Item(text: 'item1'),
    Item(text: 'item2'),
    Item(text: 'item3'),
  ];
  final tItemPicked = RandomItemPicked(
    itemPicked: tItemPool[0],
    itemPool: tItemPool,
  );
  final tDateTime = DateTime.now();
  final tPickHistory = PickHistory(
    picked: tItemPicked,
    dateTime: tDateTime,
  );

  setUpAll(() {
    registerFallbackValue(
      PickHistory(
        dateTime: tDateTime,
        picked: tItemPicked,
      ),
    );
  });

  test(
    'should return stream of history',
    () async {
      // arrange
      when(() => mockRandomHistoryRepository.getRandomHistory())
          .thenAnswer((_) async => Right(tStream));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right<dynamic, Stream<List<PickHistory>>>(tStream));
      verify(() => mockRandomHistoryRepository.getRandomHistory());
      verifyNoMoreInteractions(mockRandomHistoryRepository);
    },
  );

  group('should verify params', () {
    void returnVoid() {
      return;
    }

    test('for putRandomHistory if index is null', () async {
      // arrange
      when(() => mockRandomHistoryRepository.putRandomHistory(any()))
          .thenAnswer((_) async => Right(returnVoid()));
      // act
      final result = await usecase.putRandomHistory(
        HistoryParams(pickHistory: tPickHistory),
      );
      // assert
      expect(result, Right<dynamic, void>(returnVoid()));
      verify(
        () => mockRandomHistoryRepository.putRandomHistory(tPickHistory),
      );
      verifyNoMoreInteractions(mockRandomHistoryRepository);
    });

    test('for putRandomHistory if index is not null', () async {
      // arrange
      when(
        () => mockRandomHistoryRepository.putRandomHistory(
          any(),
          index: any(named: 'index'),
        ),
      ).thenAnswer((_) async => Right(returnVoid()));
      // act
      final result = await usecase.putRandomHistory(
        HistoryParams(pickHistory: tPickHistory, index: 0),
      );
      // assert
      expect(result, Right<dynamic, void>(returnVoid()));
      verify(
        () => mockRandomHistoryRepository.putRandomHistory(
          tPickHistory,
          index: 0,
        ),
      );
      verifyNoMoreInteractions(mockRandomHistoryRepository);
    });

    test('for getRandomHistoryById', () async {
      // arrange
      when(() => mockRandomHistoryRepository.getRandomHistoryById(any()))
          .thenAnswer((_) async => Right(tPickHistory));
      // act
      final result = await usecase.getRandomHistoryById(
        IdParams(id: tPickHistory.id),
      );
      // assert
      expect(result, Right<dynamic, PickHistory>(tPickHistory));
      verify(
        () => mockRandomHistoryRepository.getRandomHistoryById(tPickHistory.id),
      );
      verifyNoMoreInteractions(mockRandomHistoryRepository);
    });

    test('for clearHistory', () async {
      // arrange
      when(() => mockRandomHistoryRepository.clearAllHistory())
          .thenAnswer((_) async => Right(returnVoid()));
      // act
      final result = await usecase.clearAllHistory(NoParams());
      // assert
      expect(result, Right<dynamic, void>(returnVoid()));
      verify(() => mockRandomHistoryRepository.clearAllHistory());
      verifyNoMoreInteractions(mockRandomHistoryRepository);
    });

    test('for clearHistoryById', () async {
      // arrange
      when(() => mockRandomHistoryRepository.clearHistory(any()))
          .thenAnswer((_) async => Right(returnVoid()));
      // act
      final result = await usecase.clearHistory(
        HistoryParams(pickHistory: tPickHistory),
      );
      // assert
      expect(result, Right<dynamic, void>(returnVoid()));
      verify(
        () => mockRandomHistoryRepository.clearHistory(tPickHistory),
      );
      verifyNoMoreInteractions(mockRandomHistoryRepository);
    });
  });
}
