import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/core/error/exceptions.dart';
import 'package:random_pick/features/random/random_list/data/datasources/random_list_data_source.dart';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/data/models/random_item_picked_model.dart';

void main() {
  late RandomListDataSourceImpl dataSource;

  setUp(() {
    dataSource = RandomListDataSourceImpl();
  });

  test(
    'should return an RandomItemPicked from the given list',
    () async {
      // arrange
      const tItemPool = [
        ItemModel(text: 'Item 1'),
        ItemModel(text: 'Item 2'),
        ItemModel(text: 'Item 3'),
      ];
      // act
      final result = await dataSource.getRandomItem(tItemPool);
      // assert
      expect(result, isA<RandomItemPickedModel>());
    },
  );
  test(
    'should return an proper value in the given range',
    () async {
      // arrange
      const tItemPool = [
        ItemModel(text: 'Item 1'),
      ];
      // act
      final result = await dataSource.getRandomItem(
        tItemPool,
      );
      // assert
      expect(result.itemPicked, equals(tItemPool[0]));
    },
  );

  test(
    'should throw a length exception when length is not valid',
    () async {
      // arrange
      // length can be either 0 or tooo long when it gets exception
      const tItemPool = <ItemModel>[];
      // act
      final call = dataSource.getRandomItem;
      // assert
      expect(
          () => call(tItemPool), throwsA(const TypeMatcher<LengthException>()));
    },
  );

  test(
    'should throw a no selection exception when nothing selected',
    () async {
      // arrange
      const tItemPool = <ItemModel>[
        ItemModel(text: 'Item 1', selected: false),
      ];
      // act
      final call = dataSource.getRandomItem;
      // assert
      expect(() => call(tItemPool),
          throwsA(const TypeMatcher<NoSelectionException>()));
    },
  );
}
