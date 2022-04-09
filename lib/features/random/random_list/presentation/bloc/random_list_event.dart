part of 'random_list_bloc.dart';

abstract class RandomListEvent extends Equatable {
  const RandomListEvent();

  @override
  List<Object> get props => [];
}

/// dispatch this event to get a random item from the given
/// item pool - list of items (strings)
class GetRandomItemEvent extends RandomListEvent {
  final List<String> itemPool;

  const GetRandomItemEvent({required this.itemPool});

  @override
  List<Object> get props => [itemPool];
}
