import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_history/data/repositories/random_history_repository_impl.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/usecases/subscribe_random_history.dart';
import 'package:random_pick/features/random/random_list/data/repositories/random_list_repository_impl.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/get_random_item.dart';
import 'package:random_pick/features/random/random_list/domain/usecases/subscribe_items.dart';
import 'package:random_pick/features/random/random_list/presentation/bloc/random_list_bloc.dart';
import 'package:rxdart/subjects.dart';

class MockGetRandomItem extends Mock implements GetRandomItem {}

class MockSubscribeItems extends Mock implements SubscribeItems {}

class MockSubscribeRandomHistory extends Mock
    implements SubscribeRandomHistory {}

void main() {
  late RandomListBloc bloc;
  late MockGetRandomItem mockGetRandomItem;
  late MockSubscribeItems mockSubscribeItems;
  late MockSubscribeRandomHistory mockSubscribeRandomHistory;

  setUp(() {
    mockGetRandomItem = MockGetRandomItem();
    mockSubscribeItems = MockSubscribeItems();
    mockSubscribeRandomHistory = MockSubscribeRandomHistory();
    bloc = RandomListBloc(
      getRandomItem: mockGetRandomItem,
      subscribeItems: mockSubscribeItems,
      subscribeRandomHistory: mockSubscribeRandomHistory,
    );
  });

  void returnVoid() {
    return;
  }

  const tRandomListState = RandomListState();

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
    final tRandomPickHistory = PickHistory(
      dateTime: DateTime.now(),
      picked: tRandomItemPicked,
    );

    setUpAll(() {
      registerFallbackValue(NoParams());
      registerFallbackValue(HistoryParams(pickHistory: tRandomPickHistory));
    });

    void successClearItems() {
      when(() => mockSubscribeItems.clearItemPool())
          .thenAnswer((_) async => Right(returnVoid()));
    }

    void setUpMockHistorySuccess() {
      when(() => mockSubscribeRandomHistory.putRandomHistory(any()))
          .thenAnswer((_) async => Right(returnVoid()));
    }

    test(
      'should call and validate get random item usecase'
      ' along with clear item pool',
      () async {
        // arrange
        when(() => mockGetRandomItem(any()))
            .thenAnswer((_) async => Right(tRandomItemPicked));
        successClearItems();
        setUpMockHistorySuccess();
        // act
        bloc.add(const GetRandomItemEvent());
        await untilCalled(() => mockGetRandomItem(any()));
        await untilCalled(() => mockSubscribeItems.clearItemPool());
        // assert
        verify(() => mockGetRandomItem(NoParams()));
        verify(() => mockSubscribeItems.clearItemPool());
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () {
        // arrange
        when(() => mockGetRandomItem(any()))
            .thenAnswer((_) async => Right(tRandomItemPicked));
        successClearItems();
        setUpMockHistorySuccess();
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.randomPickLoading,
          ),
          tRandomListState.copyWith(
            randomItemPicked: () => tRandomItemPicked,
            status: () => ItemsSubscriptionStatus.randomPickLoaded,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent());
      },
    );

    test(
      'should emit [Loading, Error] when get random item is length failed',
      () {
        // arrange
        when(() => mockGetRandomItem(any()))
            .thenAnswer((_) async => Left(LengthFailure()));
        successClearItems();
        setUpMockHistorySuccess();
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.randomPickLoading,
          ),
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.error,
            errorMessage: () =>
                'Invalid length - Please provide at least one item to at '
                'most 2^32-1 items',
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent());
      },
    );

    test(
      'should emit [Loading, Error] when get random item is selection failed',
      () {
        // arrange
        when(() => mockGetRandomItem(any()))
            .thenAnswer((_) async => Left(NoSelectionFailure()));
        successClearItems();
        setUpMockHistorySuccess();
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.randomPickLoading,
          ),
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.error,
            errorMessage: () =>
                'No item selected - Please, select at least one item',
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent());
      },
    );

    test(
      // Adding the whitespace will make the string longer than 80 characters
      // ignore: missing_whitespace_between_adjacent_strings
      'should emit [Loading, Error] when data is gotten successfully'
      'but, history is not saved',
      () {
        // arrange
        when(() => mockGetRandomItem(any()))
            .thenAnswer((_) async => Right(tRandomItemPicked));
        successClearItems();
        when(() => mockSubscribeRandomHistory.putRandomHistory(any()))
            .thenAnswer((_) async => Left(HistoryAlreadyExistsFailure()));
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.randomPickLoading,
          ),
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.error,
            errorMessage: () => historyAlreadyExists,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const GetRandomItemEvent());
      },
    );
  });

  group('subscribe items', () {
    final tItemPool = <Item>[
      Item(text: 'item1'),
    ];
    final tUpdatedItemPool = <Item>[
      Item(text: 'newItem1'),
    ];

    test(
      'should load and subscribe items',
      () {
        // arrange
        final tController = BehaviorSubject<List<Item>>.seeded(const []);
        final tStream = tController.asBroadcastStream();
        when(() => mockSubscribeItems(any()))
            .thenAnswer((_) async => Right(tStream));
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.itemsLoading,
          ),
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.itemsLoaded,
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const ItemsSubscriptionRequested());
      },
    );

    test(
      'should fail when subscribe items',
      () {
        // arrange
        when(() => mockSubscribeItems(any()))
            .thenAnswer((_) async => const Left(UnknownFailure()));
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.itemsLoading,
          ),
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.error,
            errorMessage: () => 'Unexpected error',
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const ItemsSubscriptionRequested());
      },
    );

    test(
      'should fail when subscribe items in right',
      () {
        // arrange
        final tController = BehaviorSubject<List<Item>>.seeded(const [])
          // add error to stream
          ..addError(const UnknownFailure());
        final tStream = tController.asBroadcastStream();
        when(() => mockSubscribeItems(any()))
            .thenAnswer((_) async => Right(tStream));
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.itemsLoading,
          ),
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.error,
            errorMessage: () => 'Unexpected error',
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(const ItemsSubscriptionRequested());
      },
    );

    test(
      'should not emit on item added',
      () {
        // act
        when(() => mockSubscribeItems.addItemToPool(Params(item: tItemPool[0])))
            .thenAnswer((_) async => Right(returnVoid()));
        // assert later
        final expected = <dynamic>[];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(ItemAddRequested(item: tItemPool[0]));
      },
    );

    test(
      'should not emit on items update',
      () {
        // act
        when(
          () => mockSubscribeItems
              .updateItemPool(ListParams(items: tUpdatedItemPool)),
        ).thenAnswer((_) async => Right(returnVoid()));
        // assert later
        final expected = <dynamic>[];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(ItemsUpdateRequested(items: tUpdatedItemPool));
      },
    );

    test(
      'should not emit on item removed',
      () {
        // act
        when(
          () =>
              mockSubscribeItems.removeItemFromPool(Params(item: tItemPool[0])),
        ).thenAnswer((_) async => Right(returnVoid()));
        // assert later
        final expected = <dynamic>[];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(ItemRemoveRequested(item: tItemPool[0]));
      },
    );

    test(
      'should emit error on item removed failed',
      () {
        // act
        when(
          () =>
              mockSubscribeItems.removeItemFromPool(Params(item: tItemPool[0])),
        ).thenAnswer((_) async => Left(ItemNotFoundFailure()));
        // assert later
        final expected = [
          tRandomListState.copyWith(
            status: () => ItemsSubscriptionStatus.error,
            errorMessage: () => 'Item not found to remove',
          ),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(ItemRemoveRequested(item: tItemPool[0]));
      },
    );
  });
}
