import 'package:equatable/equatable.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';

/// Entity used to store the [randomNumber] picked from the [numberRange]
class RandomNumberPicked extends Equatable {
  /// create a new [RandomNumberPicked] where
  /// [randomNumber] is picked from [numberRange]
  const RandomNumberPicked({
    required this.randomNumber,
    required this.numberRange,
  });

  /// picked random number from [numberRange]
  final int randomNumber;

  /// the number range from which the [randomNumber] was picked
  final NumberRange numberRange;

  @override
  List<Object?> get props => [randomNumber, numberRange];
}
