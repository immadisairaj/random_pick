part of 'random_list_bloc.dart';

/// abstract class event for the random list bloc
abstract class RandomListEvent extends Equatable {
  /// create a random list event
  const RandomListEvent();

  @override
  List<Object> get props => [];
}

/// dispatch this event to get a random item from the item pool
class GetRandomItemEvent extends RandomListEvent {
  /// get random item event
  const GetRandomItemEvent();
}

/// dispatch this event to subscribe to the item pool
class ItemsSubscriptionRequested extends RandomListEvent {
  /// subscribe to the item pool
  const ItemsSubscriptionRequested();
}

/// dispatch this event to add/edit an item in the item pool
class ItemAddRequested extends RandomListEvent {
  /// create a new [ItemAddRequested] with the [item] to be added/edited
  const ItemAddRequested({required this.item});

  /// the item to be added/edited
  final Item item;

  @override
  List<Object> get props => [item];
}

/// dispatch this event to update all items with new items in the item pool
class ItemsUpdateRequested extends RandomListEvent {
  /// create a new [ItemsUpdateRequested] with the [items] to be added
  const ItemsUpdateRequested({required this.items});

  /// the items to be added
  final List<Item> items;

  @override
  List<Object> get props => [items];
}

/// dispatch this event to remove an item from the item pool
class ItemRemoveRequested extends RandomListEvent {
  /// create a new [ItemRemoveRequested] with the [item] to be removed
  const ItemRemoveRequested({required this.item});

  /// the item to be removed
  final Item item;

  @override
  List<Object> get props => [item];
}
