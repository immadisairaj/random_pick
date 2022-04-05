import 'package:equatable/equatable.dart';

import 'number_range.dart';

class RandomNumberPicked extends Equatable {
  final int randomNumber;
  final NumberRange numberRange;

  const RandomNumberPicked({
    required this.randomNumber,
    required this.numberRange,
  });

  @override
  List<Object?> get props => [randomNumber, numberRange];
}
