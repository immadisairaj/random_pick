import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/random_item_picked.dart';
import '../repositories/random_list_repository.dart';

/// usecase class to get random number by taking
/// [NoParams]
class GetRandomItem implements UseCase<RandomItemPicked, NoParams> {
  final RandomListRepository repository;

  /// constructor to initialize the [repository]
  GetRandomItem(this.repository);

  /// get random item from repository
  @override
  Future<Either<Failure, RandomItemPicked>> call(NoParams noParams) async {
    return await repository.getRandomItem();
  }
}
