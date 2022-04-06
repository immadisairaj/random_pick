import 'package:flutter_test/flutter_test.dart';

import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';

void main() {
  group('number range initialization', () {
    group('min and max values', () {
      test('min is less than max', () {
        // use default min value
        expect(() => NumberRange(max: 10), returnsNormally);
        // use custom min and max value
        expect(() => NumberRange(min: 3, max: 6), returnsNormally);
        // use custom min and max value where min is negative
        expect(() => NumberRange(min: -3, max: 6), returnsNormally);
      });
      test('min is equal to max', () {
        // use default min value and min is equal to max
        expect(() => NumberRange(max: 0), returnsNormally);
        // use custom min value and min is equal to max
        expect(() => NumberRange(min: 3, max: 3), returnsNormally);
      });
      test('min is greater than max', () {
        // max is less than min
        expect(() => NumberRange(min: 5, max: 1),
            throwsA(const TypeMatcher<ArgumentError>()));
      });
      test('difference between min and max', () {
        // range is less than (2^32)-1
        expect(() => NumberRange(min: 1, max: (1 << 32) - 1), returnsNormally);
        // range is greater than or equal to (2^32)-1
        expect(() => NumberRange(min: 1, max: 1 << 32),
            throwsA(const TypeMatcher<ArgumentError>()));
      });
    });
    group('error messages', () {
      test('values error', () {
        expect(
            () => NumberRange(min: 5, max: 3),
            throwsA(isArgumentError.having(
                (e) => e.message,
                'values error message',
                'min must be less than or equal to max')));
      });
      test('difference error', () {
        expect(
            () => NumberRange(max: (1 << 32) - 1),
            throwsA(isArgumentError.having(
                (e) => e.message,
                'difference error message',
                'the total list size must be less than (2^32)-1,'
                    ' i.e. 4,294,967,295')));
      });
    });
  });
}
