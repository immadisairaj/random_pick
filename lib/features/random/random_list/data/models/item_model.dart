import '../../domain/entities/item.dart';

class ItemModel extends Item {
  const ItemModel({
    required String text,
    bool selected = true,
  }) : super(text: text, selected: selected);

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      text: json['text'],
      selected: json['selected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'selected': selected,
    };
  }
}
