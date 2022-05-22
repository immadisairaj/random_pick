import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/domain/repositories/random_list_repository.dart';

/// usecase class to get random number by taking
/// [NoParams]
class GetRandomItem implements UseCase<RandomItemPicked, NoParams> {
  /// constructor to initialize the [repository]
  GetRandomItem(this.repository);

  /// repository to get random number
  final RandomListRepository repository;

  /// get random item from repository
  @override
  Future<Either<Failure, RandomItemPicked>> call(NoParams noParams) {
    return repository.getRandomItem();
  }
}
