import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/repositories/random_list_repository.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/subscribe_items.dart';

import 'get_random_item_test.mocks.dart';

@GenerateMocks([RandomListRepository])
void main() {
  late SubscribeItems usecase;
  late MockRandomListRepository mockRandomListRepository;

  setUp(() {
    mockRandomListRepository = MockRandomListRepository();
    usecase = SubscribeItems(mockRandomListRepository);
  });

  StreamController<List<Item>> tController = StreamController<List<Item>>();
  Stream<List<Item>> tStream = tController.stream;
  final tItemPool = [
    Item(text: 'item1'),
    Item(text: 'item2'),
    Item(text: 'item3'),
  ];
  test(
    'should return stream of items for pool',
    () async {
      // arrange
      when(mockRandomListRepository.getItemPool())
          .thenAnswer((_) async => Right(tStream));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tStream));
      verify(mockRandomListRepository.getItemPool());
      verifyNoMoreInteractions(mockRandomListRepository);
    },
  );

  group('should verify params', () {
    void returnVoid() {
      return;
    }

    test(
      'for addItemToPool',
      () async {
        // arrange
        when(mockRandomListRepository.addItemToPool(any))
            .thenAnswer((_) async => Right(returnVoid()));
        // act
        final result = await usecase.addItemToPool(Params(item: tItemPool[0]));
        // assert
        expect(result, Right(returnVoid()));
        verify(mockRandomListRepository.addItemToPool(tItemPool[0]));
        verifyNoMoreInteractions(mockRandomListRepository);
      },
    );

    test(
      'for removeItemFromPool',
      () async {
        // arrange
        when(mockRandomListRepository.removeItemFromPool(any))
            .thenAnswer((_) async => Right(returnVoid()));
        // act
        final result =
            await usecase.removeItemFromPool(Params(item: tItemPool[0]));
        // assert
        expect(result, Right(returnVoid()));
        verify(mockRandomListRepository.removeItemFromPool(tItemPool[0]));
        verifyNoMoreInteractions(mockRandomListRepository);
      },
    );

    test(
      'for clearItemPool',
      () async {
        // arrange
        when(mockRandomListRepository.clearItemPool())
            .thenAnswer((_) async => Right(returnVoid()));
        // act
        final result = await usecase.clearItemPool();
        // assert
        expect(result, Right(returnVoid()));
        verify(mockRandomListRepository.clearItemPool());
        verifyNoMoreInteractions(mockRandomListRepository);
      },
    );

    test('for updateItemPool', () async {
      // arrange
      when(mockRandomListRepository.updateItemPool(any))
          .thenAnswer((_) async => Right(returnVoid()));
      // act
      final result = await usecase.updateItemPool(ListParams(items: tItemPool));
      // assert
      expect(result, Right(returnVoid()));
      verify(mockRandomListRepository.updateItemPool(tItemPool));
      verifyNoMoreInteractions(mockRandomListRepository);
    });
  });
}
