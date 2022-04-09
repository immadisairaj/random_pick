part of 'random_number_bloc.dart';

abstract class RandomNumberEvent extends Equatable {
  const RandomNumberEvent();

  @override
  List<Object> get props => [];
}

/// dispatch this event to get a random number from the given
/// number range: min - max
class GetRandomNumberForRange extends RandomNumberEvent {
  final String min;
  final String max;

  const GetRandomNumberForRange({required this.min, required this.max});

  @override
  List<Object> get props => [min, max];
}
