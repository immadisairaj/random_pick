import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/number_range.dart';
import '../../../../core/error/failures.dart';
import '../repositories/random_number_repository.dart';

/// usecase class to get random number by taking
/// [NumberRange] as [Params]
class GetRandomNumber implements UseCase<int, Params> {
  final RandomNumberRepository repository;

  /// constructor to initialize the [repository]
  GetRandomNumber(this.repository);

  /// get random number from repository
  @override
  Future<Either<Failure, int>> call(Params params) async {
    return await repository.getRandomNumber(params.numberRange);
  }
}

/// params class which include [NumberRange] as named parameter
class Params extends Equatable {
  final NumberRange numberRange;

  /// named parameter constructor to pass [NumberRange]
  const Params({required this.numberRange});

  @override
  List<Object?> get props => [numberRange];
}
