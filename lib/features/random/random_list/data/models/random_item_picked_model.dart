import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';

/// model for the [RandomItemPicked]
class RandomItemPickedModel extends RandomItemPicked {
  /// creates a [RandomItemPickedModel] which contains
  /// the functions for json conversions
  const RandomItemPickedModel({
    required super.itemPicked,
    required super.itemPool,
  });

  /// converts the json map to [RandomItemPickedModel]
  factory RandomItemPickedModel.fromJson(Map<String, dynamic> json) {
    return RandomItemPickedModel(
      itemPicked:
          ItemModel.fromJson(json['itemPicked'] as Map<String, dynamic>),
      itemPool: List<Map<String, dynamic>>.from(json['itemPool'] as List)
          .map<ItemModel>(ItemModel.fromJson)
          .toList(),
    );
  }

  /// converts the [RandomItemPickedModel] to json map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'itemPicked': (itemPicked as ItemModel).toJson(),
      'itemPool': itemPool.map((item) => (item as ItemModel).toJson()).toList(),
    };
  }
}
