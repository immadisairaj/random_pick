import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';

/// model for [NumberRange]
class NumberRangeModel extends NumberRange {
  /// creates a [NumberRangeModel] which contains the
  /// the json conversion functions
  NumberRangeModel({
    required super.min,
    required super.max,
  });

  /// converts the json map to [NumberRangeModel]
  factory NumberRangeModel.fromJson(Map<String, dynamic> json) {
    return NumberRangeModel(
      min: json['min'] as int,
      max: json['max'] as int,
    );
  }

  /// converts the [NumberRangeModel] to json map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'min': min,
      'max': max,
    };
  }
}
