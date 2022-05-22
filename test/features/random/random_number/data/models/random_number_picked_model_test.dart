import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/data/models/random_number_picked_model.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberRangeModel = NumberRangeModel(min: 1, max: 10);
  final tRandomNumberPickedModel = RandomNumberPickedModel(
    randomNumber: 5,
    numberRange: tNumberRangeModel,
  );

  test('should be a sub class of RandomNumberPicked entity', () {
    // assert
    expect(tRandomNumberPickedModel, isA<RandomNumberPicked>());
  });

  group('dealing with JSON', () {
    test('should return a valid model from JSON', () {
      // arange
      final jsonMap = json.decode(fixture('random_number_picked.json'))
          as Map<String, dynamic>;
      // act
      final result = RandomNumberPickedModel.fromJson(jsonMap);
      // assert
      expect(result, tRandomNumberPickedModel);
    });

    test('should return a valid JSON from model', () {
      // act
      final result = tRandomNumberPickedModel.toJson();
      // assert
      final expectedMap = {
        'randomNumber': 5,
        'numberRange': {
          'min': 1,
          'max': 10,
        },
      };
      expect(result, expectedMap);
    });
  });
}
