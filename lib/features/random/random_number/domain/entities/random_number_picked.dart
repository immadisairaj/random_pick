import 'package:equatable/equatable.dart';

import 'number_range.dart';

/// Entity used to store the [randomNumber] picked from the [numberRange]
class RandomNumberPicked extends Equatable {
  /// picked random number from [numberRange]
  final int randomNumber;

  /// the number range from which the [randomNumber] was picked
  final NumberRange numberRange;

  /// create a new [RandomNumberPicked] where
  /// [randomNumber] is picked from [numberRange]
  const RandomNumberPicked({
    required this.randomNumber,
    required this.numberRange,
  });

  @override
  List<Object?> get props => [randomNumber, numberRange];
}
