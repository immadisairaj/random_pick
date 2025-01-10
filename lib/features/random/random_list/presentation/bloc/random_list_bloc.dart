import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

part 'random_list_event.dart';
part 'random_list_state.dart';

// constants to show in RandomNumberError
const String _lengthError =
    'Invalid length - Please provide at least one item to at most 2^32-1 items';
const String _selectionError =
    'No item selected - Please, select at least one item';
const String _itemNotFoundError = 'Item not found to remove';

/// error message on add a pick history and the history already exists
const String historyAlreadyExists =
    'History already exists to save - please use another id';

/// business logic for random list
class RandomListBloc extends Bloc<RandomListEvent, RandomListState> {
  /// Random list bloc which handles the subscribing to items
  /// and picking a random item from the item pool
  RandomListBloc({
    required this.getRandomItem,
    required this.subscribeItems,
    required this.subscribeRandomHistory,
  }) : super(const RandomListState()) {
    on<ItemsSubscriptionRequested>(_onItemsSubscriptionRequested);
    on<ItemAddRequested>(_onItemAddRequested);
    on<ItemsUpdateRequested>(_onItemsUpdateRequested);
    on<ItemRemoveRequested>(_onItemRemoveRequested);
    on<GetRandomItemEvent>(_getRandomItemEvent);
  }

  /// usecase to get random item
  final GetRandomItem getRandomItem;

  /// usecase to subscribe to items
  final SubscribeItems subscribeItems;

  /// usecase to subscribe to history and put the history into database
  final SubscribeRandomHistory subscribeRandomHistory;

  /// logic of what to do when the [GetRandomItemEvent] event is dispatched
  Future<void> _getRandomItemEvent(
    GetRandomItemEvent event,
    Emitter<RandomListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: () => ItemsSubscriptionStatus.randomPickLoading,
      ),
    );
    final failureOrResult = await getRandomItem(NoParams());

    await failureOrResult.fold(
      (failure) async => emit(
        state.copyWith(
          status: () => ItemsSubscriptionStatus.error,
          errorMessage: () => _mapFailureToMessage(failure),
        ),
      ),
      (randomItemPicked) async {
        await subscribeItems.clearItemPool();
        final dateTime = DateTime.now();
        final failureOrResult = await subscribeRandomHistory.putRandomHistory(
          HistoryParams(
            pickHistory:
                PickHistory(dateTime: dateTime, picked: randomItemPicked),
          ),
        );
        await failureOrResult.fold(
          (failure) async => emit(
            state.copyWith(
              status: () => ItemsSubscriptionStatus.error,
              errorMessage: () => _mapFailureToMessage(failure),
            ),
          ),
          (right) {
            emit(
              state.copyWith(
                status: () => ItemsSubscriptionStatus.randomPickLoaded,
                randomItemPicked: () => randomItemPicked,
              ),
            );
          },
        );
      },
    );
  }

  /// logic of what to do when the [ItemsSubscriptionRequested] event is
  /// dispatched
  Future<void> _onItemsSubscriptionRequested(
    ItemsSubscriptionRequested event,
    Emitter<RandomListState> emit,
  ) async {
    emit(state.copyWith(status: () => ItemsSubscriptionStatus.itemsLoading));

    final failureOrItems = await subscribeItems(NoParams());
    await failureOrItems.fold(
      (failure) async => emit(
        state.copyWith(
          status: () => ItemsSubscriptionStatus.error,
          errorMessage: () => _mapFailureToMessage(failure),
        ),
      ),
      (items) async => emit.forEach<List<Item>>(
        items,
        onData: (items) => state.copyWith(
          status: () => ItemsSubscriptionStatus.itemsLoaded,
          itemPool: () => items,
        ),
        onError: (_, __) => state.copyWith(
          status: () => ItemsSubscriptionStatus.error,
          errorMessage: () => _mapFailureToMessage(const UnknownFailure()),
        ),
      ),
    );
  }

  /// logic of what to do when the [ItemAddRequested] event is dispatched
  Future<void> _onItemAddRequested(
    ItemAddRequested event,
    Emitter<RandomListState> emit,
  ) async {
    await subscribeItems.addItemToPool(Params(item: event.item));
  }

  /// logic of what to do when the [ItemsUpdateRequested] event is dispatched
  Future<void> _onItemsUpdateRequested(
    ItemsUpdateRequested event,
    Emitter<RandomListState> emit,
  ) async {
    await subscribeItems.updateItemPool(ListParams(items: event.items));
  }

  /// logic of what to do when the [ItemRemoveRequested] event is dispatched
  Future<void> _onItemRemoveRequested(
    ItemRemoveRequested event,
    Emitter<RandomListState> emit,
  ) async {
    final failureOrItems =
        await subscribeItems.removeItemFromPool(Params(item: event.item));
    await failureOrItems.fold(
      (failure) async => emit(
        state.copyWith(
          status: () => ItemsSubscriptionStatus.error,
          errorMessage: () => _mapFailureToMessage(failure),
        ),
      ),
      (_) {},
    );
  }

  /// maps the failure to a message using the failure type
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (LengthFailure):
        return _lengthError;
      case const (NoSelectionFailure):
        return _selectionError;
      case const (ItemNotFoundFailure):
        return _itemNotFoundError;
      case const (HistoryAlreadyExistsFailure):
        return historyAlreadyExists;
      default:
        return 'Unexpected error';
    }
  }
}
