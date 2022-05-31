import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_history/data/repositories/random_history_repository_impl.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/usecases/subscribe_random_history.dart';

part 'random_history_event.dart';
part 'random_history_state.dart';

// constants to show in error state
/// error message on add a pick history and the history already exists
const String historyAlreadyExists =
    'History already exists to save - please use another id';
// const String _historyNotFoundError = 'History not found';

/// business logic for random history
class RandomHistoryBloc extends Bloc<RandomHistoryEvent, RandomHistoryState> {
  /// Random history bloc which handles the subscription of history
  RandomHistoryBloc({
    required this.subscribeRandomHistory,
  }) : super(const RandomHistoryState()) {
    on<HistorySubscriptionRequested>(_onHistorySubscriptionRequested);
    on<HistoryAddRequested>(_onHistoryAddRequested);
    // on<GetHistoryByIdRequested>(_getHistoryByIdRequested);
  }

  /// usecase to subscribe to history
  final SubscribeRandomHistory subscribeRandomHistory;

  /// logic of what to do when the [HistorySubscriptionRequested] event is
  /// dispatched
  Future<void> _onHistorySubscriptionRequested(
    HistorySubscriptionRequested event,
    Emitter<RandomHistoryState> emit,
  ) async {
    emit(state.copyWith(status: () => RandomHistoryStatus.loading));

    final failureOrResult = await subscribeRandomHistory(NoParams());
    await failureOrResult.fold(
      (failure) async => emit(
        state.copyWith(
          status: () => RandomHistoryStatus.error,
          errorMessage: () => _mapFailureToMessage(failure),
        ),
      ),
      (history) async => {
        await emit.forEach<List<PickHistory>>(
          history,
          onData: (historyList) => state.copyWith(
            status: () => RandomHistoryStatus.loaded,
            historyList: () => historyList,
          ),
          onError: (_, __) => state.copyWith(
            status: () => RandomHistoryStatus.error,
            errorMessage: () => _mapFailureToMessage(const UnknownFailure()),
          ),
        )
      },
    );
  }

  /// logic of what to do when the [HistoryAddRequested] event is dispatched
  FutureOr<void> _onHistoryAddRequested(
    HistoryAddRequested event,
    Emitter<RandomHistoryState> emit,
  ) async {
    final failureOrResult = await subscribeRandomHistory.putRandomHistory(
      HistoryParams(
        pickHistory: event.pickHistory,
      ),
    );
    await failureOrResult.fold(
      (failure) async => emit(
        state.copyWith(
          status: () => RandomHistoryStatus.error,
          errorMessage: () => _mapFailureToMessage(failure),
        ),
      ),
      (right) {
        // do nothing
      },
    );
  }

  // implement it later when needed
  // /// logic of what to do when the [GetHistoryByIdRequested] event is dispatched
  // FutureOr<void> _getHistoryByIdRequested(
  //   GetHistoryByIdRequested event,
  //   Emitter<RandomHistoryState> emit,
  // ) async {
  //   final failureOrResult = await subscribeRandomHistory
  //    .getRandomHistoryById(
  //     IdParams(
  //       id: event.id,
  //     ),
  //   );
  //   await failureOrResult.fold(
  //     (failure) async => emit(
  //       state.copyWith(
  //         status: () => RandomHistoryStatus.error,
  //         errorMessage: () => _mapFailureToMessage(failure),
  //       ),
  //     ),
  //     (right) {
  //       // do nothing
  //     },
  //   );
  // }

  /// maps the failure to a message using the failure type
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case HistoryAlreadyExistsFailure:
        return historyAlreadyExists;
      // case HistoryNotFoundFailure:
      //   return _historyNotFoundError;
      default:
        return 'Unexpected error';
    }
  }
}
