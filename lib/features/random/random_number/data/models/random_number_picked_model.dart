import '../../data/models/number_range_model.dart';
import '../../domain/entities/random_number_picked.dart';

class RandomNumberPickedModel extends RandomNumberPicked {
  const RandomNumberPickedModel({
    required super.randomNumber,
    required super.numberRange,
  });

  factory RandomNumberPickedModel.fromJson(Map<String, dynamic> json) {
    return RandomNumberPickedModel(
      randomNumber: json['randomNumber'],
      numberRange: NumberRangeModel.fromJson(json['numberRange']),
    );
  }

  Map<String, dynamic> toJson() {
    final numberRangeModel = NumberRangeModel(
      min: numberRange.min,
      max: numberRange.max,
    );
    return {
      'randomNumber': randomNumber,
      'numberRange': numberRangeModel.toJson(),
    };
  }
}
