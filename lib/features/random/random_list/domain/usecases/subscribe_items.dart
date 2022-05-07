import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/item.dart';
import '../repositories/random_list_repository.dart';

/// usecase class to get random number by taking
/// [NoParams]
class SubscribeItems implements UseCase<Stream<List<Item>>, NoParams> {
  final RandomListRepository repository;

  SubscribeItems(this.repository);

  /// get item pool from repository
  @override
  Future<Either<Failure, Stream<List<Item>>>> call(NoParams noParams) async {
    return await repository.getItemPool();
  }

  /// add item to the pool
  Future<Either<Failure, void>> addItemToPool(Params params) async {
    return await repository.addItemToPool(params.item);
  }

  /// remove item from the pool
  Future<Either<Failure, void>> removeItemFromPool(Params params) async {
    return await repository.removeItemFromPool(params.item);
  }

  /// clear the pool
  Future<Either<Failure, void>> clearItemPool() async {
    return await repository.clearItemPool();
  }

  /// update item pool with the items
  Future<Either<Failure, void>> updateItemPool(ListParams listParams) async {
    return await repository.updateItemPool(listParams.items);
  }
}

class Params extends Equatable {
  final Item item;

  const Params({required this.item});

  @override
  List<Object> get props => [item];
}

class ListParams extends Equatable {
  final List<Item> items;

  const ListParams({required this.items});

  @override
  List<Object> get props => [items];
}
