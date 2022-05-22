import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  final tItemModel = ItemModel(id: '1', text: 'Item 1');
  test('should be a sub class of Item entity', () {
    // assert
    expect(tItemModel, isA<Item>());
  });

  test('should return properly when copy with', () {
    // act
    final tItemModelCopy = tItemModel.copyWith();
    // assert
    expect(tItemModelCopy, tItemModel);
  });

  group('dealing with JSON', () {
    test('should return a valid model from JSON', () {
      // arange
      final jsonMap = json.decode(fixture('item.json')) as Map<String, dynamic>;
      // act
      final result = ItemModel.fromJson(jsonMap);
      // assert
      expect(result, tItemModel);
    });

    test('should return a valid JSON from model', () {
      // act
      final result = tItemModel.toJson();
      // assert
      final expectedMap = {
        'id': '1',
        'text': 'Item 1',
        'selected': true,
      };
      expect(result, expectedMap);
    });
  });
}
