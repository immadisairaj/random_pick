import 'package:equatable/equatable.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';
import 'package:uuid/uuid.dart';

/// Entity for random pick history
class PickHistory extends Equatable {
  /// create a new pick history
  ///
  /// for now, the picked type can be either
  /// [RandomItemPicked] or [RandomNumberPicked]
  /// else, it throws an error
  PickHistory({
    required this.dateTime, required this.picked, String? id,
  })  : assert(
          id == null || id.isNotEmpty,
          'id cannot be empty',
        ),
        id = id ?? const Uuid().v4() {
    if (picked is! RandomItemPicked && picked is! RandomNumberPicked) {
      throw ArgumentError(
        'picked must be of type RandomItemPicked or RandomNumberPicked',
      );
    }
  }

  /// unique itentifier for the pick
  final String id;

  /// Timestamp of the pick
  final DateTime dateTime;

  /// The picked type
  final dynamic picked;

  @override
  List<Object?> get props => [id, dateTime, picked];
}
