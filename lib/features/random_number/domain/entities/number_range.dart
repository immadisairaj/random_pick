import 'package:equatable/equatable.dart';

class NumberRange extends Equatable {
  /// range in which min included,
  /// defaults to 0
  final int min;

  /// range in which max is excluded
  final int max;

  /// create a new [NumberRange] where
  /// [min] is included and [max] is excluded
  ///
  /// [min] defaults to 0
  ///
  /// max range is 2^32, i.e. 4,294,967,296
  ///
  /// usage:
  /// ```dart
  /// NumberRange(max: 10); // range from 0 to 9
  /// NumberRange(min: 1, max: 10); // range from 1 to 9
  /// ```
  ///
  /// throws an error if [min] is not less than [max]
  /// throws error if range is not within 2^32
  NumberRange({
    this.min = 0,
    required this.max,
  }) {
    if (min >= max) {
      throw ArgumentError('min must be less than max');
    } else if ((max - min) >= (1 << 32)) {
      throw ArgumentError('the total list size must be less than 2^32,'
          ' i.e. 4,294,967,296');
    }
  }

  @override
  List<Object?> get props => [min, max];
}
