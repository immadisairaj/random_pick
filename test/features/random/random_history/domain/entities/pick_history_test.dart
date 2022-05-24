import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

void main() {
  group('random pick history initialization', () {
    final randomItemPicked = RandomItemPicked(
      itemPicked: Item(
        id: '1',
        text: 'item 1',
      ),
      itemPool: [
        Item(
          id: '1',
          text: 'item 1',
        ),
        Item(
          id: '2',
          text: 'item 2',
        ),
        Item(
          id: '3',
          text: 'item 3',
        ),
      ],
    );
    final randomNumberPicked = RandomNumberPicked(
      randomNumber: 1,
      numberRange: NumberRange(min: 1, max: 10),
    );
    test('random item pick type', () {
      expect(
        () => PickHistory(
          dateTime: DateTime.now(),
          picked: randomItemPicked,
        ),
        returnsNormally,
      );
    });

    test('random number picked', () {
      expect(
        () => PickHistory(
          dateTime: DateTime.now(),
          picked: randomNumberPicked,
        ),
        returnsNormally,
      );
    });

    test('other types', () {
      expect(
        () => PickHistory(
          dateTime: DateTime.now(),
          picked: null,
        ),
        throwsA(const TypeMatcher<ArgumentError>()),
      );
    });

    test('other types error message', () {
      expect(
        () => PickHistory(
          dateTime: DateTime.now(),
          picked: 0,
        ),
        throwsA(
          isArgumentError.having(
            (e) => e.message,
            'other types error message',
            'picked must be of type RandomItemPicked or RandomNumberPicked',
          ),
        ),
      );
    });
  });
}
