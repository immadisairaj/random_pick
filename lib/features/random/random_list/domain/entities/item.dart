import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// core item used by picker
class Item extends Equatable {
  /// unique identifier of the item
  final String id;

  /// text to display
  final String text;

  /// indicate if the item is to be picked,
  /// defaults to true
  final bool selected;

  /// create a new item
  ///
  /// - id - will randomly fill if not provided
  /// - text - text to display
  /// - selected - indicate if the item is to be picked, defaults to true
  Item({
    String? id,
    required this.text,
    this.selected = true,
  })  : assert(
          id == null || id.isNotEmpty,
        ),
        id = id ?? const Uuid().v4();

  Item copyWith({
    String? id,
    String? text,
    bool? selected,
  }) {
    return Item(
      id: id ?? this.id,
      text: text ?? this.text,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [id, text, selected];
}
