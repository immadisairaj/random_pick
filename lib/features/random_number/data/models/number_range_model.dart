import '../../domain/entities/number_range.dart';

class NumberRangeModel extends NumberRange {
  NumberRangeModel({
    required int min,
    required int max,
  }) : super(min: min, max: max);

  factory NumberRangeModel.fromJson(Map<String, dynamic> json) {
    return NumberRangeModel(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}
