part of 'random_number_bloc.dart';

abstract class RandomNumberState extends Equatable {
  const RandomNumberState();

  @override
  List<Object> get props => [];
}

/// Initial state for random number
class RandomNumberEmpty extends RandomNumberState {}

/// state when random number pick is loading
class RandomNumberLoading extends RandomNumberState {}

/// state when the random number pick is successful
///
/// [randomNumberPicked] contains the picked and number range
class RandomNumberLoaded extends RandomNumberState {
  final RandomNumberPicked randomNumberPicked;

  const RandomNumberLoaded({required this.randomNumberPicked});

  @override
  List<Object> get props => [randomNumberPicked];
}

/// state when the random number pick is unsuccessful
///
/// provides an [errorMessage] of why it is unsuccessful
class RandomNumberError extends RandomNumberState {
  final String errorMessage;

  const RandomNumberError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
