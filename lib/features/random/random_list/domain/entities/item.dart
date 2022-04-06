import 'package:equatable/equatable.dart';

/// core item used by picker
class Item extends Equatable {
  /// text to display
  final String text;

  /// indicate if the item is to be picked,
  /// defaults to true
  final bool selected;

  /// create a new item
  ///
  /// - text - text to display
  /// - selected - indicate if the item is to be picked, defaults to true
  const Item({
    required this.text,
    this.selected = true,
  });

  @override
  List<Object?> get props => [text, selected];
}
