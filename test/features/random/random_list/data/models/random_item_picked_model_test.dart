import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/data/models/random_item_picked_model.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  const tItemPool = [
    ItemModel(text: 'Item 1'),
    ItemModel(text: 'Item 2'),
  ];
  final tRandomItemPicked = RandomItemPickedModel(
    itemPicked: tItemPool[0],
    itemPool: tItemPool,
  );
  test('should be a sub class of Item entity', () {
    // assert
    expect(tRandomItemPicked, isA<RandomItemPicked>());
  });

  group('dealing with JSON', () {
    test('should return a valid model from JSON', () {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('random_item_picked.json'));
      // act
      final result = RandomItemPickedModel.fromJson(jsonMap);
      // assert
      expect(result, tRandomItemPicked);
    });

    test('should return a valid JSON from model', () {
      // act
      final result = tRandomItemPicked.toJson();
      // assert
      final expectedMap = {
        'itemPicked': {'text': 'Item 1', 'selected': true},
        'itemPool': [
          {'text': 'Item 1', 'selected': true},
          {'text': 'Item 2', 'selected': true}
        ]
      };
      expect(result, expectedMap);
    });
  });
}
