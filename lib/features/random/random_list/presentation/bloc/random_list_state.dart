part of 'random_list_bloc.dart';

abstract class RandomListState extends Equatable {
  const RandomListState();

  @override
  List<Object> get props => [];
}

/// Initial state for random list
class RandomListEmpty extends RandomListState {}

/// state when random item pick is loading
class RandomListLoading extends RandomListState {}

/// state when the random item pick is successful
///
/// [randomItemPicked] contains the picked and item pool
class RandomListLoaded extends RandomListState {
  final RandomItemPicked randomItemPicked;

  const RandomListLoaded({required this.randomItemPicked});

  @override
  List<Object> get props => [randomItemPicked];
}

/// state when the random item pick is unsuccessful
///
/// provides an [errorMessage] of why it is unsuccessful
class RandomListError extends RandomListState {
  final String errorMessage;

  const RandomListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
