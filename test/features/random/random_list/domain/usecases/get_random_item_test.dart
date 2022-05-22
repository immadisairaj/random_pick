import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/domain/repositories/random_list_repository.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/get_random_item.dart';

import 'get_random_item_test.mocks.dart';

@GenerateMocks([RandomListRepository])
void main() {
  late GetRandomItem usecase;
  late MockRandomListRepository mockRandomListRepository;

  setUp(() {
    mockRandomListRepository = MockRandomListRepository();
    usecase = GetRandomItem(mockRandomListRepository);
  });

  final tItemPool = [
    Item(text: 'item1'),
    Item(text: 'item2'),
    Item(text: 'item3'),
  ];
  final tItemPicked = tItemPool[0];
  final tRandomItemPicked =
      RandomItemPicked(itemPicked: tItemPicked, itemPool: tItemPool);

  test(
    'should return item picked from pool',
    () async {
      // arrange
      when(mockRandomListRepository.getRandomItem())
          .thenAnswer((_) async => Right(tRandomItemPicked));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right<dynamic, RandomItemPicked>(tRandomItemPicked));
      verify(mockRandomListRepository.getRandomItem());
      verifyNoMoreInteractions(mockRandomListRepository);
    },
  );
}
