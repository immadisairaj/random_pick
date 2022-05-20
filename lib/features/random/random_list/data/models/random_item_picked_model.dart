import '../../domain/entities/item.dart';
import '../../domain/entities/random_item_picked.dart';
import 'item_model.dart';

class RandomItemPickedModel extends RandomItemPicked {
  const RandomItemPickedModel({
    required super.itemPicked,
    required super.itemPool,
  });

  factory RandomItemPickedModel.fromJson(Map<String, dynamic> json) {
    return RandomItemPickedModel(
      itemPicked: ItemModel.fromJson(json['itemPicked']),
      itemPool: (json['itemPool'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemPicked': toItemModel(itemPicked).toJson(),
      'itemPool': itemPool.map((item) => toItemModel(item).toJson()).toList(),
    };
  }

  ItemModel toItemModel(Item item) {
    return ItemModel(
      id: item.id,
      text: item.text,
      selected: item.selected,
    );
  }
}
