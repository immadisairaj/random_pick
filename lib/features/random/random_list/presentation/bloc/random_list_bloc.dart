import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../data/repositories/random_list_repository_impl.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/random_item_picked.dart';
import '../../domain/usecases/get_random_item.dart';
import '../../domain/usecases/subscribe_items.dart';

part 'random_list_event.dart';
part 'random_list_state.dart';

// constants to show in RandomNumberError
const String lengthError =
    'Invalid length - Please provide at least one item to at most 2^32-1 items';
const String selectionError =
    'No item selected - Please, select at least one item';
const String itemNotFoundError = 'Item not found to remove';

class RandomListBloc extends Bloc<RandomListEvent, RandomListState> {
  final GetRandomItem getRandomItem;
  final SubscribeItems subscribeItems;

  RandomListBloc({
    required this.getRandomItem,
    required this.subscribeItems,
  }) : super(const RandomListState()) {
    on<ItemsSubscriptionRequested>(_onItemsSubscriptionRequested);
    on<ItemAddRequested>(_onItemAddRequested);
    on<ItemRemoveRequested>(_onItemRemoveRequested);
    on<GetRandomItemEvent>(_getRandomItemEvent);
  }

  /// logic of what to do when the [GetRandomItemEvent] event is dispatched
  Future<void> _getRandomItemEvent(
    GetRandomItemEvent event,
    Emitter<RandomListState> emit,
  ) async {
    emit(RandomListPickLoading());
    final failureOrResult = await getRandomItem(NoParams());

    await failureOrResult.fold(
      (failure) async =>
          emit(RandomListError(errorMessage: _mapFailureToMessage(failure))),
      (randomItemPicked) async {
        await subscribeItems.clearItemPool();
        emit(
          RandomListPickLoaded(randomItemPicked: randomItemPicked),
        );
      },
    );
  }

  Future<void> _onItemsSubscriptionRequested(
    ItemsSubscriptionRequested event,
    Emitter<RandomListState> emit,
  ) async {
    emit(state.copyWith(status: () => ItemsSubscriptionStatus.loading));

    final failureOrItems = await subscribeItems(NoParams());
    await failureOrItems.fold(
      (failure) async =>
          emit(RandomListError(errorMessage: _mapFailureToMessage(failure))),
      (items) async => {
        await emit.forEach<List<Item>>(
          items,
          onData: (items) => state.copyWith(
            status: () => ItemsSubscriptionStatus.loaded,
            itemPool: () => items,
          ),
          onError: (_, __) => RandomListError(
              errorMessage: _mapFailureToMessage(const UnknownFailure())),
        )
      },
    );
  }

  Future<void> _onItemAddRequested(
    ItemAddRequested event,
    Emitter<RandomListState> emit,
  ) async {
    await subscribeItems.addItemToPool(Params(item: event.item));
  }

  Future<void> _onItemRemoveRequested(
    ItemRemoveRequested event,
    Emitter<RandomListState> emit,
  ) async {
    final failureOrItems =
        await subscribeItems.removeItemFromPool(Params(item: event.item));
    await failureOrItems.fold(
        (failure) async =>
            emit(RandomListError(errorMessage: _mapFailureToMessage(failure))),
        ((_) {}));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case LengthFailure:
        return lengthError;
      case NoSelectionFailure:
        return selectionError;
      case ItemNotFoundFailure:
        return itemNotFoundError;
      default:
        return 'Unexpected error';
    }
  }
}
