part of 'random_number_bloc.dart';

/// state for [RandomNumberBloc]
abstract class RandomNumberState extends Equatable {
  /// creates a new [RandomNumberState]
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
  /// create a new [RandomNumberLoaded] with [randomNumberPicked]
  /// to provide in the event
  const RandomNumberLoaded({required this.randomNumberPicked});

  /// picked random number from the number range
  final RandomNumberPicked randomNumberPicked;

  @override
  List<Object> get props => [randomNumberPicked];
}

/// state when the random number pick is unsuccessful
///
/// provides an [errorMessage] of why it is unsuccessful
class RandomNumberError extends RandomNumberState {
  /// create a new [RandomNumberError] with [errorMessage]
  const RandomNumberError({required this.errorMessage});

  /// error message of why the random number pick is unsuccessful
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
