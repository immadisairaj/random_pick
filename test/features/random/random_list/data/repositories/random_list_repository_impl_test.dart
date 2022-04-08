import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_pick/features/random/random_list/data/datasources/random_list_data_source.dart';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/data/models/random_item_picked_model.dart';
import 'package:random_pick/features/random/random_list/data/repositories/random_list_repository_impl.dart';

import 'random_list_repository_impl_test.mocks.dart';

@GenerateMocks([RandomListDataSource])
void main() {
  late RandomListRepositoryImpl repository;
  late MockRandomListDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRandomListDataSource();
    repository = RandomListRepositoryImpl(
      dataSource: mockDataSource,
    );
  });

  test(
    'should return if picked properly',
    () async {
      // arrange
      const tItemPool = [
        ItemModel(text: 'Item 1'),
        ItemModel(text: 'Item 2'),
        ItemModel(text: 'Item 3'),
      ];
      final tItemPicked = tItemPool[0];
      final tRandomItemPicked = RandomItemPickedModel(
        itemPicked: tItemPicked,
        itemPool: tItemPool,
      );

      when(mockDataSource.getRandomItem(any))
          .thenAnswer((_) async => tRandomItemPicked);
      // act
      final result = await repository.getRandomItem(tItemPool);
      // assert
      verify(mockDataSource.getRandomItem(tItemPool));
      expect(result, equals(Right(tRandomItemPicked)));
    },
  );

  test(
    'should return length failure if length of list is not valid',
    () async {
      // arrange
      const tItemPool = <ItemModel>[];

      when(mockDataSource.getRandomItem(any)).thenThrow(LengthException());
      // act
      final result = await repository.getRandomItem(tItemPool);
      // assert
      verify(mockDataSource.getRandomItem(tItemPool));
      expect(result, equals(Left(LengthFailure())));
    },
  );

  test(
    'should return no selection failure if none of list is selected',
    () async {
      // arrange
      const tItemPool = <ItemModel>[
        ItemModel(text: 'Item 1', selected: false),
      ];

      when(mockDataSource.getRandomItem(any)).thenThrow(NoSelectionException());
      // act
      final result = await repository.getRandomItem(tItemPool);
      // assert
      verify(mockDataSource.getRandomItem(tItemPool));
      expect(result, equals(Left(NoSelectionFailure())));
    },
  );
}
