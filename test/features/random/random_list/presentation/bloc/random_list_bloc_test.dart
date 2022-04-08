import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_pick/core/utils/input_converter.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/get_random_item.dart';
import 'package:random_pick/features/random/random_list/presentation/bloc/random_list_bloc.dart';

import 'random_list_bloc_test.mocks.dart';

@GenerateMocks([GetRandomItem, InputConverter])
void main() {
  late RandomListBloc bloc;
  late MockGetRandomItem mockGetRandomItem;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomItem = MockGetRandomItem();
    mockInputConverter = MockInputConverter();
    bloc = RandomListBloc(
      getRandomItem: mockGetRandomItem,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be RandomListEmpty', () {
    expect(bloc.state, equals(RandomListEmpty()));
  });

  group('get random item picked from item pool', () {
    const tItems = [
      'item1',
    ];
    const tItemPool = [
      Item(text: 'item1'),
    ];
    final tItemPicked = tItemPool[0];
    final tRandomItemPicked = RandomItemPicked(
      itemPicked: tItemPicked,
      itemPool: tItemPool,
    );

    setUpMockInputSuccess() {
      when(mockInputConverter.stringsToItemPool(any)).thenReturn(tItemPool);
    }

    test(
      'should call input converter validate and convert strings to NumberRange'
      'and get random number from the usecase',
      () async {
        // arrange
        setUpMockInputSuccess();
        when(mockGetRandomItem(any))
            .thenAnswer((_) async => Right(tRandomItemPicked));
        // act
        bloc.add(const GetRandomItemEvent(itemPool: tItems));
        await untilCalled(mockInputConverter.stringsToItemPool(tItems));
        await untilCalled(mockGetRandomItem(any));
        // assert
        verify(mockInputConverter.stringsToItemPool(tItems));
        verify(mockGetRandomItem(const Params(itemPool: tItemPool)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputSuccess();
        when(mockGetRandomItem(any))
            .thenAnswer((_) async => Right(tRandomItemPicked));
        // assert later
        final expected = [
          // RandomNumberEmpty(),
          RandomListLoading(),
          RandomListLoaded(randomItemPicked: tRandomItemPicked),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent(itemPool: tItems));
      },
    );
  });
}
