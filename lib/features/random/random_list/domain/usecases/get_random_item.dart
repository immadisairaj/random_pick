import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/item.dart';
import '../entities/random_item_picked.dart';
import '../repositories/random_list_repository.dart';

class GetRandomItem implements UseCase<RandomItemPicked, Params> {
  final RandomListRepository repository;

  GetRandomItem(this.repository);

  @override
  Future<Either<Failure, RandomItemPicked>> call(Params params) async {
    return await repository.getRandomItem(params.itemPool);
  }
}

class Params extends Equatable {
  final List<Item> itemPool;

  const Params({required this.itemPool});

  @override
  List<Object?> get props => [itemPool];
}
