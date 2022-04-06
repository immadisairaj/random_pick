import 'package:equatable/equatable.dart';

import 'item.dart';

class RandomItemPicked extends Equatable {
  final Item itemPicked;
  final List<Item> itemPool;

  const RandomItemPicked({
    required this.itemPicked,
    required this.itemPool,
  });

  @override
  List<Object?> get props => [itemPicked, itemPool];
}
