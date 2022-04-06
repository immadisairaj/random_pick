part of 'random_number_bloc.dart';

abstract class RandomNumberEvent extends Equatable {
  const RandomNumberEvent();

  @override
  List<Object> get props => [];
}

class GetRandomNumberForRange extends RandomNumberEvent {
  final String min;
  final String max;

  const GetRandomNumberForRange({required this.min, required this.max});

  @override
  List<Object> get props => [min, max];
}
