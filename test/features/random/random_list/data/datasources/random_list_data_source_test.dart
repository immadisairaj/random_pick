import 'package:flutter_test/flutter_test.dart';
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
      final tItemPool = [
        ItemModel(text: 'Item 1'),
        ItemModel(text: 'Item 2'),
        ItemModel(text: 'Item 3'),
      ];
      await dataSource.updateItemPool(tItemPool);
      // act
      final result = await dataSource.getRandomItem();
      // assert
      expect(result, isA<RandomItemPickedModel>());
    },
  );
  test(
    'should return an proper value in the given range',
    () async {
      // arrange
      final tItemPool = [
        ItemModel(text: 'Item 1'),
      ];
      await dataSource.updateItemPool(tItemPool);
      // act
      final result = await dataSource.getRandomItem();
      // assert
      expect(result.itemPicked, equals(tItemPool[0]));
    },
  );

  test(
    'should throw a length exception when length is not valid',
    () async {
      // arrange
      // length can be either 0 or tooo long when it gets exception
      // act
      final call = dataSource.getRandomItem;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<LengthException>()));
    },
  );

  test(
    'should throw a no selection exception when nothing selected',
    () async {
      // arrange
      final tItemPool = <ItemModel>[
        ItemModel(text: 'Item 1', selected: false),
      ];
      await dataSource.updateItemPool(tItemPool);
      // act
      final call = dataSource.getRandomItem;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<NoSelectionException>()));
    },
  );

  test('should check if added into pool', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(text: 'Item 1'),
    ];
    await dataSource.updateItemPool(tItemPool);
    // act
    final tItem = ItemModel(text: 'Item 2');
    await dataSource.addItemToPool(tItem);
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, contains(tItem));
    });
  });

  test('should check return value of getItem', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(text: 'Item 1'),
    ];
    await dataSource.updateItemPool(tItemPool);
    // act
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, isA<List<ItemModel>>());
    });
  });

  test('should check if remove item from pool', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(text: 'Item 1'),
    ];
    await dataSource.updateItemPool(tItemPool);
    // act
    final tItem = tItemPool[0];
    await dataSource.removeItemFromPool(tItem);
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, isNot(contains(tItem)));
    });
  });

  test('should check if remove item from pool fails', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(text: 'Item 1'),
    ];
    await dataSource.updateItemPool(tItemPool);
    // act
    final tItem = ItemModel(text: 'Item 2');
    final call = dataSource.removeItemFromPool;
    // assert
    expect(
        () => call(tItem), throwsA(const TypeMatcher<ItemNotFoundException>()));
  });

  test('should check if add items to pool', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(text: 'Item 1'),
      ItemModel(text: 'Item 2'),
    ];
    // act
    await dataSource.updateItemPool(tItemPool);
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, equals(tItemPool));
    });
  });

  test('should check if add duplicate item to pool', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(text: 'Item 1'),
    ];
    await dataSource.updateItemPool(tItemPool);
    // act
    await dataSource.addItemToPool(tItemPool[0]);
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, equals(tItemPool));
    });
  });

  test('should check if update item in pool', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(id: '1', text: 'Item 1'),
    ];
    await dataSource.updateItemPool(tItemPool);
    // act
    final tItemUpdate = <ItemModel>[
      tItemPool[0].copyWith(selected: false),
    ];
    await dataSource.addItemToPool(tItemUpdate[0]);
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, equals(tItemUpdate));
    });
  });

  test('should check if clear item pool', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(text: 'Item 1'),
    ];
    await dataSource.updateItemPool(tItemPool);
    // act
    await dataSource.clearItemPool();
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, equals(<ItemModel>[]));
    });
  });

  test('should check if update duplicate items to pool', () async {
    // arrange
    final tItemPool = <ItemModel>[
      ItemModel(id: '1', text: 'Item 1'),
    ];
    final tDuplicateItemPool = <ItemModel>[
      ItemModel(id: '1', text: 'Item 1'),
      ItemModel(id: '1', text: 'Item 1'),
    ];
    // act
    await dataSource.updateItemPool(tDuplicateItemPool);
    final result = await dataSource.getItemPool();
    // assert
    result.listen((value) {
      expect(value, equals(tItemPool));
    });
  });
}
