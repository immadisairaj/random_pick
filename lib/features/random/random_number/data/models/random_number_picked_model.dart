import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

/// model for [RandomNumberPicked]
class RandomNumberPickedModel extends RandomNumberPicked {
  /// creates a [RandomNumberPickedModel] which contains
  /// the functions for json conversions
  const RandomNumberPickedModel({
    required super.randomNumber,
    required super.numberRange,
  });

  /// converts the json map to [RandomNumberPickedModel]
  factory RandomNumberPickedModel.fromJson(Map<String, dynamic> json) {
    return RandomNumberPickedModel(
      randomNumber: json['randomNumber'] as int,
      numberRange: NumberRangeModel.fromJson(
        json['numberRange'] as Map<String, dynamic>,
      ),
    );
  }

  /// converts the [RandomNumberPickedModel] to json map
  Map<String, dynamic> toJson() {
    final numberRangeModel = NumberRangeModel(
      min: numberRange.min,
      max: numberRange.max,
    );
    return <String, dynamic>{
      'randomNumber': randomNumber,
      'numberRange': numberRangeModel.toJson(),
    };
  }
}
