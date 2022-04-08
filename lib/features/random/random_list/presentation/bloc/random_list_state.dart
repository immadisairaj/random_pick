part of 'random_list_bloc.dart';

abstract class RandomListState extends Equatable {
  const RandomListState();

  @override
  List<Object> get props => [];
}

class RandomListEmpty extends RandomListState {}

class RandomListLoading extends RandomListState {}

class RandomListLoaded extends RandomListState {
  final RandomItemPicked randomItemPicked;

  const RandomListLoaded({required this.randomItemPicked});

  @override
  List<Object> get props => [randomItemPicked];
}

class RandomListError extends RandomListState {
  final String errorMessage;

  const RandomListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
