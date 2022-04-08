part of 'random_list_bloc.dart';

abstract class RandomListEvent extends Equatable {
  const RandomListEvent();

  @override
  List<Object> get props => [];
}

class GetRandomItemEvent extends RandomListEvent {
  final List<String> itemPool;

  const GetRandomItemEvent({required this.itemPool});

  @override
  List<Object> get props => [itemPool];
}
