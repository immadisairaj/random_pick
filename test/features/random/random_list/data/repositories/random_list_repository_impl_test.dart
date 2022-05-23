import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/features/random/random_list/data/datasources/random_list_data_source.dart';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/data/models/random_item_picked_model.dart';
import 'package:random_pick/features/random/random_list/data/repositories/random_list_repository_impl.dart';

class MockRandomListDataSource extends Mock implements RandomListDataSource {}

void main() {
  late RandomListRepositoryImpl repository;
  late MockRandomListDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRandomListDataSource();
    repository = RandomListRepositoryImpl(
      dataSource: mockDataSource,
    );
  });

  setUpAll(() {
    registerFallbackValue(ItemModel(text: 'text'));
  });

  test(
    'should return if picked properly',
    () async {
      // arrange
      final tItemPool = [
        ItemModel(text: 'Item 1'),
        ItemModel(text: 'Item 2'),
        ItemModel(text: 'Item 3'),
      ];
      final tItemPicked = tItemPool[0];
      final tRandomItemPicked = RandomItemPickedModel(
        itemPicked: tItemPicked,
        itemPool: tItemPool,
      );

      when(() => mockDataSource.getRandomItem())
          .thenAnswer((_) async => tRandomItemPicked);
      // act
      final result = await repository.getRandomItem();
      // assert
      verify(() => mockDataSource.getRandomItem());
      expect(
        result,
        equals(
          Right<dynamic, RandomItemPickedModel>(tRandomItemPicked),
        ),
      );
    },
  );

  test(
    'should return length failure if length of list is not valid',
    () async {
      // arrange
      when(() => mockDataSource.getRandomItem()).thenThrow(LengthException());
      // act
      final result = await repository.getRandomItem();
      // assert
      verify(() => mockDataSource.getRandomItem());
      expect(result, equals(Left<LengthFailure, dynamic>(LengthFailure())));
    },
  );

  test(
    'should return no selection failure if none of list is selected',
    () async {
      // arrange
      when(() => mockDataSource.getRandomItem())
          .thenThrow(NoSelectionException());
      // act
      final result = await repository.getRandomItem();
      // assert
      verify(() => mockDataSource.getRandomItem());
      expect(
        result,
        equals(
          Left<NoSelectionFailure, dynamic>(NoSelectionFailure()),
        ),
      );
    },
  );

  void returnVoid() {
    return;
  }

  test(
    'should return stream from getItemPool',
    () async {
      // arrange
      final tController = StreamController<List<ItemModel>>();
      final tStream = tController.stream;

      when(() => mockDataSource.getItemPool()).thenAnswer((_) async => tStream);
      // act
      final result = await repository.getItemPool();
      // assert
      verify(() => mockDataSource.getItemPool());
      expect(result, equals(Right<dynamic, Stream<List<ItemModel>>>(tStream)));
    },
  );

  test(
    'should verify if add item to pool',
    () async {
      // arrange
      final tItem = ItemModel(text: 'Item 1');

      when(() => mockDataSource.addItemToPool(any()))
          .thenAnswer((_) async => returnVoid());
      // act
      final result = await repository.addItemToPool(tItem);
      // assert
      verify(() => mockDataSource.addItemToPool(tItem));
      expect(result, equals(Right<dynamic, void>(returnVoid())));
    },
  );

  test(
    'should verify if add item to pool',
    () async {
      // arrange
      when(() => mockDataSource.clearItemPool())
          .thenAnswer((_) async => returnVoid());
      // act
      final result = await repository.clearItemPool();
      // assert
      verify(() => mockDataSource.clearItemPool());
      expect(result, equals(Right<dynamic, void>(returnVoid())));
    },
  );

  test(
    'should verify if update item pool',
    () async {
      // arrange
      final tItemPool = [
        ItemModel(text: 'Item 1'),
        ItemModel(text: 'Item 2'),
        ItemModel(text: 'Item 3'),
      ];

      when(() => mockDataSource.updateItemPool(any()))
          .thenAnswer((_) async => returnVoid());
      // act
      final result = await repository.updateItemPool(tItemPool);
      // assert
      verify(() => mockDataSource.updateItemPool(tItemPool));
      expect(result, equals(Right<dynamic, void>(returnVoid())));
    },
  );

  test(
    'should verify if remove item from pool',
    () async {
      // arrange
      final tItem = ItemModel(text: 'Item 1');

      when(() => mockDataSource.removeItemFromPool(any()))
          .thenAnswer((_) async => returnVoid());
      // act
      final result = await repository.removeItemFromPool(tItem);
      // assert
      verify(() => mockDataSource.removeItemFromPool(tItem));
      expect(result, equals(Right<dynamic, void>(returnVoid())));
    },
  );

  test(
    'should fail if remove item from pool',
    () async {
      // arrange
      final tItem = ItemModel(text: 'Item 1');

      when(() => mockDataSource.removeItemFromPool(any()))
          .thenThrow(ItemNotFoundException());
      // act
      final result = await repository.removeItemFromPool(tItem);
      // assert
      verify(() => mockDataSource.removeItemFromPool(tItem));
      expect(
        result,
        equals(
          Left<ItemNotFoundFailure, dynamic>(ItemNotFoundFailure()),
        ),
      );
    },
  );
}
