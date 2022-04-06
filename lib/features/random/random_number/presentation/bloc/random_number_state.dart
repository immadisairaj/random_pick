part of 'random_number_bloc.dart';

abstract class RandomNumberState extends Equatable {
  const RandomNumberState();

  @override
  List<Object> get props => [];
}

class RandomNumberEmpty extends RandomNumberState {}

class RandomNumberLoading extends RandomNumberState {}

class RandomNumberLoaded extends RandomNumberState {
  final RandomNumberPicked randomNumberPicked;

  const RandomNumberLoaded({required this.randomNumberPicked});

  @override
  List<Object> get props => [randomNumberPicked];
}

class RandomNumberError extends RandomNumberState {
  final String errorMessage;

  const RandomNumberError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}