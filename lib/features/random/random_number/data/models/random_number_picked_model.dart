import '../../data/models/number_range_model.dart';
import '../../domain/entities/random_number_picked.dart';

class RandomNumberPickedModel extends RandomNumberPicked {
  const RandomNumberPickedModel({
    required int randomNumber,
    required NumberRangeModel numberRange,
  }) : super(
          randomNumber: randomNumber,
          numberRange: numberRange,
        );

  factory RandomNumberPickedModel.fromJson(Map<String, dynamic> json) {
    return RandomNumberPickedModel(
      randomNumber: json['randomNumber'],
      numberRange: NumberRangeModel.fromJson(json['numberRange']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'randomNumber': randomNumber,
      'numberRange': {
        'min': numberRange.min,
        'max': numberRange.max,
      },
    };
  }
}
