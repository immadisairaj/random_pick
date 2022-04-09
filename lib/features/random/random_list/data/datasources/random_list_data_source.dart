import 'dart:math';

import '../models/item_model.dart';
import '../models/random_item_picked_model.dart';

abstract class RandomListDataSource {
  /// return random item from the given [itemPool]
  ///
  /// the main data source of picking a random item
  Future<RandomItemPickedModel> getRandomItem(List<ItemModel> itemPool);
}

class RandomListDataSourceImpl implements RandomListDataSource {
  @override
  Future<RandomItemPickedModel> getRandomItem(List<ItemModel> itemPool) {
    // throw length exception if pool is empty or too long
    if (itemPool.isEmpty || itemPool.length >= (1 << 32)) {
      throw LengthException();
    }
    final filteredItemPool = itemPool.where((item) => item.selected).toList();
    // throw no selection exception if no item is selected
    if (filteredItemPool.isEmpty) {
      throw NoSelectionException();
    }
    return Future.value(RandomItemPickedModel(
      itemPicked: filteredItemPool[Random().nextInt(filteredItemPool.length)],
      itemPool: itemPool,
    ));
  }
}

/// exception when the length of the item pool is 0 or too long
class LengthException implements Exception {}

/// exception when no item is selected
class NoSelectionException implements Exception {}
