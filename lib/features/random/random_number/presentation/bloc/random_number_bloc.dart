import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/input_converter.dart';
import '../../domain/entities/random_number_picked.dart';
import '../../domain/usecases/get_random_number.dart';

part 'random_number_event.dart';
part 'random_number_state.dart';

// constants to show in RandomNumberError
const String invalidNumberRangeError =
    'Invalid range - Please, provide a range';
const String invalidInputError =
    'Invalid input - Please, provide a valid input of numbers';

class RandomNumberBloc extends Bloc<RandomNumberEvent, RandomNumberState> {
  final GetRandomNumber getRandomNumber;
  final InputConverter inputConverter;

  RandomNumberBloc({
    required this.getRandomNumber,
    required this.inputConverter,
  }) : super(RandomNumberEmpty()) {
    on<GetRandomNumberForRange>(_getNumberForRange);
  }

  /// logic of what to do when the [GetRandomNumberForRange] event is dispatched
  Future<void> _getNumberForRange(
    GetRandomNumberForRange event,
    Emitter<RandomNumberState> emit,
  ) async {
    final inputEither =
        inputConverter.stringsToNumberRange(event.min, event.max);

    inputEither.fold(
      (failure) =>
          emit(RandomNumberError(errorMessage: _mapFailureToMessage(failure))),
      (numberRange) async {
        emit(RandomNumberLoading());
        final failureOrResult =
            await getRandomNumber(Params(numberRange: numberRange));
        // left event most probably will not happen because
        // the data source repository here doesn't return a failure/left
        failureOrResult.fold(
          (failure) => _mapFailureToMessage(failure),
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
