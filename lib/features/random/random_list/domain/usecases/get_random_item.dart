import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/item.dart';
import '../entities/random_item_picked.dart';
import '../repositories/random_list_repository.dart';

/// usecase class to get random number by taking
/// [List]<[Item]> as [Params]
class GetRandomItem implements UseCase<RandomItemPicked, Params> {
  final RandomListRepository repository;

  /// constructor to initialize the [repository]
  GetRandomItem(this.repository);

  /// get random item from repository
  @override
  Future<Either<Failure, RandomItemPicked>> call(Params params) async {
    return await repository.getRandomItem(params.itemPool);
  }
}

/// params class which include [List]<[Item]> as named parameter
class Params extends Equatable {
  final List<Item> itemPool;

  /// named parameter constructor to pass [List]<[Item]>
  const Params({required this.itemPool});

  @override
  List<Object?> get props => [itemPool];
}
