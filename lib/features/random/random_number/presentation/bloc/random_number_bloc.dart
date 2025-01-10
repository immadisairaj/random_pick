import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/utils/input_converter.dart';
import 'package:random_pick/features/random/random_history/data/repositories/random_history_repository_impl.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/usecases/subscribe_random_history.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';
import 'package:random_pick/features/random/random_number/domain/usecases/get_random_number.dart';

part 'random_number_event.dart';
part 'random_number_state.dart';

// constants to show in RandomNumberError
/// invalid number range error string
const String invalidNumberRangeError =
    'Invalid range - Please, provide a valid range under 2^32';

/// invalid input error string
const String invalidInputError =
    'Invalid input - Please, provide a valid input of numbers';

/// error message on add a pick history and the history already exists
const String historyAlreadyExists =
    'History already exists to save - please use another id';

/// business logic for random number
class RandomNumberBloc extends Bloc<RandomNumberEvent, RandomNumberState> {
  /// Random number bloc which handles the picking a random number
  RandomNumberBloc({
    required this.getRandomNumber,
    required this.inputConverter,
    required this.subscribeRandomHistory,
  }) : super(RandomNumberEmpty()) {
    on<GetRandomNumberForRange>(_getNumberForRange);
  }

  /// usecase to get random number
  final GetRandomNumber getRandomNumber;

  /// input converter to convert the input to number range
  final InputConverter inputConverter;

  /// usecase to subscribe to history and put the history into database
  final SubscribeRandomHistory subscribeRandomHistory;

  /// logic of what to do when the [GetRandomNumberForRange] event is dispatched
  Future<void> _getNumberForRange(
    GetRandomNumberForRange event,
    Emitter<RandomNumberState> emit,
  ) async {
    await inputConverter.stringsToNumberRange(event.min, event.max).fold(
      (failure) async =>
          emit(RandomNumberError(errorMessage: _mapFailureToMessage(failure))),
      (numberRange) async {
        emit(RandomNumberLoading());
        final failureOrResult =
            await getRandomNumber(Params(numberRange: numberRange));
        // left event most probably will not happen because
        // the data source repository here doesn't return a failure/left
        await failureOrResult.fold(
          (failure) async => emit(
            RandomNumberError(errorMessage: _mapFailureToMessage(failure)),
          ),
          (randomNumberPicked) async {
            final dateTime = DateTime.now();
            final failureOrResult =
                await subscribeRandomHistory.putRandomHistory(
              HistoryParams(
                pickHistory:
                    PickHistory(dateTime: dateTime, picked: randomNumberPicked),
              ),
            );
            await failureOrResult.fold(
              (failure) async => emit(
                RandomNumberError(
                  errorMessage: _mapFailureToMessage(failure),
                ),
              ),
              (right) {
                emit(
                  RandomNumberLoaded(randomNumberPicked: randomNumberPicked),
                );
              },
            );
          },
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (InvalidInputFailure):
        return invalidInputError;
      case const (InvalidNumberRangeFailure):
        return invalidNumberRangeError;
      case const (HistoryAlreadyExistsFailure):
        return historyAlreadyExists;
      default:
        return 'Unexpected error';
    }
  }
}
