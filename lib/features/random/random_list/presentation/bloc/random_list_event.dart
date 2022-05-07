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

class ItemsSubscriptionRequested extends RandomListEvent {
  const ItemsSubscriptionRequested();
}

class ItemAddRequested extends RandomListEvent {
  final Item item;
  const ItemAddRequested({required this.item});

  @override
  List<Object> get props => [item];
}

class ItemRemoveRequested extends RandomListEvent {
  final Item item;
  const ItemRemoveRequested({required this.item});

  @override
  List<Object> get props => [item];
}
