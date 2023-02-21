import 'package:random_pick/features/random/random_list/domain/entities/item.dart';

/// model for the [Item]
class ItemModel extends Item {
  /// creates a [ItemModel] which contains the copyWith function and also
  /// the functions for json conversions
  ItemModel({
    required super.text,
    super.id,
    super.selected = true,
  });

  /// converts the json map to [ItemModel]
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      text: json['text'] as String,
      selected: json['selected'] as bool,
    );
  }

  /// converts the [ItemModel] to json map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'selected': selected,
    };
  }

  @override
  ItemModel copyWith({
    String? id,
    String? text,
    bool? selected,
  }) {
    return ItemModel(
      id: id ?? this.id,
      text: text ?? this.text,
      selected: selected ?? this.selected,
    );
  }
}
