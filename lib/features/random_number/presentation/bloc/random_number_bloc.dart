import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';

import '../../../../core/utils/input_converter.dart';
import '../../domain/usecases/get_random_number.dart';

part 'random_number_event.dart';
part 'random_number_state.dart';

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
    on<RandomNumberEvent>((event, emit) {
      if (event is GetRandomNumberForRange) {
        final inputEither =
            inputConverter.stringsToNumberRange(event.min, event.max);

        inputEither.fold(
          (failure) => emit(
              RandomNumberError(errorMessage: _mapFailureToMessage(failure))),
          (numberRange) async {
            emit(RandomNumberLoading());
            final failureOrResult =
                await getRandomNumber(Params(numberRange: numberRange));
            // left event most probably will not happen because
            // the data source repository here doesn't return a failure/left
            failureOrResult.fold(
              (failure) => _mapFailureToMessage(failure),
              (randomNumber) {
                emit(RandomNumberLoaded(randomNumber: randomNumber));
              },
            );
          },
        );
      }
    });
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
