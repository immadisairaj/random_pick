import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_list/data/models/random_item_picked_model.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_number/data/models/random_number_picked_model.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

/// model for the [PickHistory]
class PickHistoryModel extends PickHistory {
  /// creates a [PickHistoryModel] which contains
  /// the copyWith function and also
  /// the functions for json conversions
  PickHistoryModel({
    super.id,
    required super.dateTime,
    required super.picked,
  });

  /// converts the json map to [PickHistoryModel]
  factory PickHistoryModel.fromJson(Map<String, dynamic> json) {
    // method for converting the json map to it's picked model
    dynamic _pickedFromJson(Map<String, dynamic> picked) {
      if (picked['numberRange'] != null) {
        return RandomNumberPickedModel.fromJson(picked);
      } else if (picked['itemPool'] != null) {
        return RandomItemPickedModel.fromJson(picked);
      }
      return null;
    }

    return PickHistoryModel(
      id: json['id'] as String,
      // date time is stored as string in the json, so we are parsing it
      dateTime: DateTime.parse(json['dateTime'] as String),
      picked: _pickedFromJson(json['picked'] as Map<String, dynamic>),
    );
  }

  /// converts the [PickHistoryModel] to json map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      // store the date time as string in the json
      'dateTime': dateTime.toString(),
      'picked': _pickedToJson(picked),
    };
  }

  dynamic _pickedToJson(dynamic picked) {
    if (picked is RandomNumberPicked) {
      return (picked as RandomNumberPickedModel).toJson();
    } else if (picked is RandomItemPicked) {
      return (picked as RandomItemPickedModel).toJson();
    }
    return null;
  }
}
