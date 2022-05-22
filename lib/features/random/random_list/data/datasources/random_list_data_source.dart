import 'dart:math';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/data/models/random_item_picked_model.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:rxdart/subjects.dart';

/// data source which can be extended to implement data sources functions
abstract class RandomListDataSource {
  /// returns items from the pool
  Future<Stream<List<ItemModel>>> getItemPool();

  /// return random item
  ///
  /// the main data source of picking a random item
  Future<RandomItemPickedModel> getRandomItem();

  /// add item to the pool,
  /// also updates the item if present in pool (checks by text)
  Future<void> addItemToPool(ItemModel item);

  /// remove item from the pool
  Future<void> removeItemFromPool(ItemModel item);

  /// clear the pool
  Future<void> clearItemPool();

  /// update item pool with the items,
  /// also removes duplicate items (checks by text)
  Future<void> updateItemPool(List<ItemModel> items);
}

/// implementation of the [RandomListDataSource]
class RandomListDataSourceImpl implements RandomListDataSource {
  final _itemsStreamController =
      BehaviorSubject<List<ItemModel>>.seeded(const []);

  @override
  Future<RandomItemPickedModel> getRandomItem() {
    final itemPool = [..._itemsStreamController.value]
        .where((item) => item.text != '')
        .toList();
    // throw length exception if pool is empty or too long
    if (itemPool.isEmpty || itemPool.length >= (1 << 32)) {
      throw LengthException();
    }
    final filteredItemPool = itemPool.where((item) => item.selected).toList();
    // throw no selection exception if no item is selected
    if (filteredItemPool.isEmpty) {
      throw NoSelectionException();
    }
    return Future.value(
      RandomItemPickedModel(
        itemPicked: filteredItemPool[Random().nextInt(filteredItemPool.length)],
        itemPool: itemPool,
      ),
    );
  }

  @override
  Future<void> addItemToPool(ItemModel item) async {
    final itemPool = [..._itemsStreamController.value];
    final itemIndex = itemPool.indexWhere((i) => i.id == item.id);
    if (itemIndex >= 0) {
      itemPool[itemIndex] = item;
    } else {
      itemPool.add(item);
    }

    _itemsStreamController.add(itemPool);
  }

  @override
  Future<void> clearItemPool() async {
    final itemPool = <ItemModel>[];
    _itemsStreamController.add(itemPool);
  }

  @override
  Future<Stream<List<ItemModel>>> getItemPool() async =>
      _itemsStreamController.asBroadcastStream();

  @override
  Future<void> removeItemFromPool(Item item) async {
    final itemPool = [..._itemsStreamController.value];
    final itemIndex = itemPool.indexWhere((i) => i.id == item.id);
    if (itemIndex >= 0) {
      itemPool.removeAt(itemIndex);
    } else {
      throw ItemNotFoundException();
    }

    _itemsStreamController.add(itemPool);
  }

  @override
  Future<void> updateItemPool(List<ItemModel> items) async {
    final itemPool = [...items];
    final distinctItemPool = itemPool.toSet().toList();
    _itemsStreamController.add(distinctItemPool);
  }
}

/// exception when the length of the item pool is 0 or too long
class LengthException implements Exception {}

/// exception when no item is selected
class NoSelectionException implements Exception {}

/// exception when no item is found
class ItemNotFoundException implements Exception {}
