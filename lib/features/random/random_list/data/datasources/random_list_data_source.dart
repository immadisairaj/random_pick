import 'dart:math';

import '../../../../../core/error/exceptions.dart';
import '../models/item_model.dart';
import '../models/random_item_picked_model.dart';

abstract class RandomListDataSource {
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
