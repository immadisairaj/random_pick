import '../../domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel({
    super.id,
    required super.text,
    super.selected = true,
  });

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

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      text: json['text'],
      selected: json['selected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'selected': selected,
    };
  }
}
