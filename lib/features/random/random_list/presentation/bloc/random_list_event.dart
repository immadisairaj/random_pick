part of 'random_list_bloc.dart';

abstract class RandomListEvent extends Equatable {
  const RandomListEvent();

  @override
  List<Object> get props => [];
}

/// dispatch this event to get a random item from the item pool
class GetRandomItemEvent extends RandomListEvent {
  const GetRandomItemEvent();
}

/// dispatch this event to subscribe to the item pool
class ItemsSubscriptionRequested extends RandomListEvent {
  const ItemsSubscriptionRequested();
}

/// dispatch this event to add/edit an item in the item pool
class ItemAddRequested extends RandomListEvent {
  final Item item;
  const ItemAddRequested({required this.item});

  @override
  List<Object> get props => [item];
}

/// dispatch this event to remove an item from the item pool
class ItemRemoveRequested extends RandomListEvent {
  final Item item;
  const ItemRemoveRequested({required this.item});

  @override
  List<Object> get props => [item];
}
