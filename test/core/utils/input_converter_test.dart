import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/core/utils/input_converter.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('strings to number range', () {
    test('should return a number range when strings are proper', () {
      // arrage
      const min = '1';
      const max = '100';
      // act
      final result = inputConverter.stringsToNumberRange(min, max);
      // assert
      expect(
        result,
        Right<dynamic, NumberRange>(
          NumberRange(min: 1, max: 100),
        ),
      );
    });
    test('should return a number range failure when number range is not proper',
        () {
      // arrage
      const min = '100';
      const max = '1';
      // act
      final result = inputConverter.stringsToNumberRange(min, max);
      // assert
      expect(
        result,
        Left<InvalidNumberRangeFailure, dynamic>(
          InvalidNumberRangeFailure(),
        ),
      );
    });
    test('should return a invalid input failure when strings are convertable',
        () {
      // arrage
      const min = 'ab';
      const max = 'cd';
      // act
      final result = inputConverter.stringsToNumberRange(min, max);
      // assert
      expect(
        result,
        Left<InvalidInputFailure, dynamic>(
          InvalidInputFailure(),
        ),
      );
    });
  });
}
