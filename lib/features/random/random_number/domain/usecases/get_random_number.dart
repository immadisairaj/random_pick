import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';
import 'package:random_pick/features/random/random_number/domain/repositories/random_number_repository.dart';

/// usecase class to get random number by taking
/// [NumberRange] as [Params]
class GetRandomNumber implements UseCase<RandomNumberPicked, Params> {
  /// constructor to initialize the [repository]
  const GetRandomNumber(this.repository);

  /// repository of the random number
  final RandomNumberRepository repository;

  /// get random number from repository
  @override
  Future<Either<Failure, RandomNumberPicked>> call(Params params) {
    return repository.getRandomNumber(params.numberRange);
  }
}

/// params class which include [NumberRange] as named parameter
class Params extends Equatable {
  /// named parameter constructor to pass [NumberRange]
  const Params({required this.numberRange});

  /// number range from which random number is picked
  final NumberRange numberRange;

  @override
  List<Object?> get props => [numberRange];
}
