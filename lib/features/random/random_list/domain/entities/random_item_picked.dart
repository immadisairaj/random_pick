import 'package:equatable/equatable.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';

/// Entity used to store the [itemPicked] picked from the [itemPool]
class RandomItemPicked extends Equatable {
  /// create a new [RandomItemPicked] where
  /// [itemPicked] is picked from [itemPool]
  const RandomItemPicked({
    required this.itemPicked,
    required this.itemPool,
  });

  /// picked random number from [itemPool]
  final Item itemPicked;

  /// the item pool from which the [itemPicked] was picked
  final List<Item> itemPool;

  @override
  List<Object?> get props => [itemPicked, itemPool];
}
