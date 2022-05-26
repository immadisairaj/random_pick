import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random/random_history/data/models/pick_history_model.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/data/models/random_item_picked_model.dart';
import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/data/models/random_number_picked_model.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  final dateTime = DateTime.parse('2022-05-26 15:56:12.066156');

  final tItemPool = [
    ItemModel(id: '1', text: 'Item 1'),
    ItemModel(id: '2', text: 'Item 2'),
  ];
  final tRandomItemPicked = RandomItemPickedModel(
    itemPicked: tItemPool[0],
    itemPool: tItemPool,
  );
  final tPickHistoryItem = PickHistoryModel(
    id: 'a',
    dateTime: dateTime,
    picked: tRandomItemPicked,
  );

  final tNumberRangeModel = NumberRangeModel(min: 1, max: 10);
  final tRandomNumberPickedModel = RandomNumberPickedModel(
    randomNumber: 5,
    numberRange: tNumberRangeModel,
  );
  final tPickHistoryNumber = PickHistoryModel(
    id: 'a',
    dateTime: dateTime,
    picked: tRandomNumberPickedModel,
  );

  test('should be a sub class of PickHistory', () {
    expect(tPickHistoryItem, isA<PickHistory>());
    expect(tPickHistoryNumber, isA<PickHistory>());
  });

  group('dealing with JSON for item picked', () {
    test('should return a valid model from JSON', () {
      // arange
      final jsonMap = json.decode(fixture('pick_history_item.json'))
          as Map<String, dynamic>;
      // act
      final result = PickHistoryModel.fromJson(jsonMap);
      // assert
      expect(result, tPickHistoryItem);
    });

    test('should return a valid JSON from model', () {
      // act
      final result = tPickHistoryItem.toJson();
      // assert
      final expectedMap = {
        'id': 'a',
        'dateTime': '2022-05-26 15:56:12.066156',
        'picked': {
          'itemPicked': {'id': '1', 'text': 'Item 1', 'selected': true},
          'itemPool': [
            {'id': '1', 'text': 'Item 1', 'selected': true},
            {'id': '2', 'text': 'Item 2', 'selected': true}
          ]
        }
      };
      expect(result, expectedMap);
    });
  });

  group('dealing with JSON for number picked', () {
    test('should return a valid model from JSON', () {
      // arange
      final jsonMap = json.decode(fixture('pick_history_number.json'))
          as Map<String, dynamic>;
      // act
      final result = PickHistoryModel.fromJson(jsonMap);
      // assert
      expect(result, tPickHistoryNumber);
    });

    test('should return a valid JSON from model', () {
      // act
      final result = tPickHistoryNumber.toJson();
      // assert
      final expectedMap = {
        'id': 'a',
        'dateTime': '2022-05-26 15:56:12.066156',
        'picked': {
          'randomNumber': 5,
          'numberRange': {'min': 1, 'max': 10}
        }
      };
      expect(result, expectedMap);
    });
  });
}
