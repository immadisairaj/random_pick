import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';

void main() {
  final tItemModel = Item(text: 'Item 1');

  test('should be a sub class of Item entity', () {
    // assert
    expect(tItemModel, isA<Item>());
  });

  test('should contain id which is not null', () {
    // assert
    expect(tItemModel.id, isNotNull);
  });

  test('sould return properly when copy with', () {
    // act
    final tItemModelCopy = tItemModel.copyWith();
    // assert
    expect(tItemModelCopy, tItemModel);
  });
}
