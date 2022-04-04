import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:random_pick/features/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random_number/domain/entities/number_range.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberRangeModel = NumberRangeModel(min: 1, max: 10);

  test('should be a sub class of NumberRange entity', () {
    // assert
    expect(tNumberRangeModel, isA<NumberRange>());
  });

  group('dealing with JSON', () {
    test('should return a valid model from JSON', () {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('number_range.json'));
      // act
      final result = NumberRangeModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberRangeModel);
    });

    test('should return a valid JSON from model', () {
      // act
      final result = tNumberRangeModel.toJson();
      // assert
      final expectedMap = {
        'min': 1,
        'max': 10,
      };
      expect(result, expectedMap);
    });
  });
}
