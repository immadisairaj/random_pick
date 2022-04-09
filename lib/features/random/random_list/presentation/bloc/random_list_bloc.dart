import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/input_converter.dart';
import '../../data/repositories/random_list_repository_impl.dart';
import '../../domain/entities/random_item_picked.dart';
import '../../domain/usecases/get_random_item.dart';

part 'random_list_event.dart';
part 'random_list_state.dart';

// constants to show in RandomNumberError
const String lengthError =
    'Invalid length - Please provide at least one item to at most 2^32-1 items';
const String selectionError =
    'No item selected - Please, select at least one item';

class RandomListBloc extends Bloc<RandomListEvent, RandomListState> {
  final GetRandomItem getRandomItem;
  final InputConverter inputConverter;

  RandomListBloc({
    required this.getRandomItem,
    required this.inputConverter,
  }) : super(RandomListEmpty()) {
    on<GetRandomItemEvent>(_getRandomItemEvent);
  }

  /// logic of what to do when the [GetRandomItemEvent] event is dispatched
  Future<void> _getRandomItemEvent(
    GetRandomItemEvent event,
    Emitter<RandomListState> emit,
  ) async {
    final inputItemPool = inputConverter.stringsToItemPool(event.itemPool);

    emit(RandomListLoading());
    final failureOrResult =
        await getRandomItem(Params(itemPool: inputItemPool));

    failureOrResult.fold(
      (failure) =>
          emit(RandomListError(errorMessage: _mapFailureToMessage(failure))),
      (randomItemPicked) {
        emit(
          RandomListLoaded(randomItemPicked: randomItemPicked),
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case LengthFailure:
        return lengthError;
      case NoSelectionFailure:
        return selectionError;
      default:
        return 'Unexpected error';
    }
  }
}
