import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/utils/input_converter.dart';
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

/// business logic for random number
class RandomNumberBloc extends Bloc<RandomNumberEvent, RandomNumberState> {
  /// Random number bloc which handles the picking a random number
  RandomNumberBloc({
    required this.getRandomNumber,
    required this.inputConverter,
  }) : super(RandomNumberEmpty()) {
    on<GetRandomNumberForRange>(_getNumberForRange);
  }

  /// usecase to get random number
  final GetRandomNumber getRandomNumber;

  /// input converter to convert the input to number range
  final InputConverter inputConverter;

  /// logic of what to do when the [GetRandomNumberForRange] event is dispatched
  Future<void> _getNumberForRange(
    GetRandomNumberForRange event,
    Emitter<RandomNumberState> emit,
  ) async {
    inputConverter.stringsToNumberRange(event.min, event.max).fold(
      (failure) =>
          emit(RandomNumberError(errorMessage: _mapFailureToMessage(failure))),
      (numberRange) async {
        emit(RandomNumberLoading());
        final failureOrResult =
            await getRandomNumber(Params(numberRange: numberRange));
        // left event most probably will not happen because
        // the data source repository here doesn't return a failure/left
        failureOrResult.fold(
          _mapFailureToMessage,
          (randomNumberPicked) {
            emit(
              RandomNumberLoaded(randomNumberPicked: randomNumberPicked),
            );
          },
        );
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case InvalidInputFailure:
        return invalidInputError;
      case InvalidNumberRangeFailure:
        return invalidNumberRangeError;
      default:
        return 'Unexpected error';
    }
  }
}
