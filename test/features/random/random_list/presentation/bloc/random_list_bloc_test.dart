import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_list/data/repositories/random_list_repository_impl.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/get_random_item.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/subscribe_items.dart';
import 'package:random_pick/features/random/random_list/presentation/bloc/random_list_bloc.dart';
import 'package:rxdart/subjects.dart';

import 'random_list_bloc_test.mocks.dart';

@GenerateMocks([GetRandomItem, SubscribeItems])
void main() {
  late RandomListBloc bloc;
  late MockGetRandomItem mockGetRandomItem;
  late MockSubscribeItems mockSubscribeItems;

  setUp(() {
    mockGetRandomItem = MockGetRandomItem();
    mockSubscribeItems = MockSubscribeItems();
    bloc = RandomListBloc(
      getRandomItem: mockGetRandomItem,
      subscribeItems: mockSubscribeItems,
    );
  });

  void returnVoid() {
    return;
  }

  test('initial state should be RandomList with default status', () {
    expect(bloc.state, equals(const RandomListState()));
  });

  group('get random item picked from item pool', () {
    final tItemPool = [
      Item(text: 'item1'),
    ];
    final tItemPicked = tItemPool[0];
    final tRandomItemPicked = RandomItemPicked(
      itemPicked: tItemPicked,
      itemPool: tItemPool,
    );

    successClearItems() {
      when(mockSubscribeItems.clearItemPool())
          .thenAnswer((_) async => Right(returnVoid()));
    }

    test(
      'should call and validate get random item usecase'
      ' along with clear item pool',
      () async {
        // arrange
        when(mockGetRandomItem(any))
            .thenAnswer((_) async => Right(tRandomItemPicked));
        successClearItems();
        // act
        bloc.add(const GetRandomItemEvent());
        await untilCalled(mockGetRandomItem(any));
        await untilCalled(mockSubscribeItems.clearItemPool());
        // assert
        verify(mockGetRandomItem(NoParams()));
        verify(mockSubscribeItems.clearItemPool());
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetRandomItem(any))
            .thenAnswer((_) async => Right(tRandomItemPicked));
        successClearItems();
        // assert later
        final expected = [
          RandomListPickLoading(),
          RandomListPickLoaded(randomItemPicked: tRandomItemPicked),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent());
      },
    );

    test(
      'should emit [Loading, Error] when get random item is length failed',
      () async {
        // arrange
        when(mockGetRandomItem(any))
            .thenAnswer((_) async => Left(LengthFailure()));
        successClearItems();
        // assert later
        final expected = [
          RandomListPickLoading(),
          const RandomListError(
              errorMessage:
                  'Invalid length - Please provide at least one item to at '
                  'most 2^32-1 items'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent());
      },
    );

    test(
      'should emit [Loading, Error] when get random item is selection failed',
      () async {
        // arrange
        when(mockGetRandomItem(any))
            .thenAnswer((_) async => Left(NoSelectionFailure()));
        successClearItems();
        // assert later
        final expected = [
          RandomListPickLoading(),
          const RandomListError(
              errorMessage:
                  'No item selected - Please, select at least one item'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent());
      },
    );
  });

  group('subscribe items', () {
    const RandomListState tRandomListState = RandomListState();
    final tItemPool = <Item>[
      Item(text: 'item1'),
    ];

    test(
      'should load and subscribe items',
      () async {
        // arrange
        final tController = BehaviorSubject<List<Item>>.seeded(const []);
        Stream<List<Item>> tStream = tController.asBroadcastStream();
        when(mockSubscribeItems(any)).thenAnswer((_) async => Right(tStream));
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.loading,
          ),
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.loaded,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const ItemsSubscriptionRequested());
      },
    );

    test(
      'should fail when subscribe items',
      () async {
        // arrange
        when(mockSubscribeItems(any))
            .thenAnswer((_) async => const Left(UnknownFailure()));
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.loading,
          ),
          const RandomListError(errorMessage: 'Unexpected error'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const ItemsSubscriptionRequested());
      },
    );

    test(
      'should not emit on item added',
      () async {
        // act
        when(mockSubscribeItems.addItemToPool(Params(item: tItemPool[0])))
            .thenAnswer((_) async => Right(returnVoid()));
        // assert later
        final expected = [];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(ItemAddRequested(item: tItemPool[0]));
      },
    );

    test(
      'should not emit on item removed',
      () async {
        // act
        when(mockSubscribeItems.removeItemFromPool(Params(item: tItemPool[0])))
            .thenAnswer((_) async => Right(returnVoid()));
        // assert later
        final expected = [];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(ItemRemoveRequested(item: tItemPool[0]));
      },
    );

    test(
      'should emit error on item removed failed',
      () async {
        // act
        when(mockSubscribeItems.removeItemFromPool(Params(item: tItemPool[0])))
            .thenAnswer((_) async => Left(ItemNotFoundFailure()));
        // assert later
        final expected = [
          const RandomListError(errorMessage: 'Item not found to remove'),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(ItemRemoveRequested(item: tItemPool[0]));
      },
    );
  });
}