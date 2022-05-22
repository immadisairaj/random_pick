part of 'random_number_bloc.dart';

/// event for [RandomNumberBloc]
abstract class RandomNumberEvent extends Equatable {
  /// creates a new [RandomNumberEvent]
  const RandomNumberEvent();

  @override
  List<Object> get props => [];
}

/// dispatch this event to get a random number from the given
/// number range: min - max
class GetRandomNumberForRange extends RandomNumberEvent {
  /// get random number from the given number range
  const GetRandomNumberForRange({required this.min, required this.max});

  /// min value of the range
  final String min;

  /// max value of the range
  final String max;

  @override
  List<Object> get props => [min, max];
}
