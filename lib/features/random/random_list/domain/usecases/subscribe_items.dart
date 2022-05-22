import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/repositories/random_list_repository.dart';

/// usecase class to get random number by taking
/// [NoParams]
class SubscribeItems implements UseCase<Stream<List<Item>>, NoParams> {
  /// subscribe to the items, gets item pool
  SubscribeItems(this.repository);

  /// repository for subscribing to the items and make operations
  final RandomListRepository repository;

  /// get item pool from repository
  @override
  Future<Either<Failure, Stream<List<Item>>>> call(NoParams noParams) {
    return repository.getItemPool();
  }

  /// add item to the pool
  Future<Either<Failure, void>> addItemToPool(Params params) {
    return repository.addItemToPool(params.item);
  }

  /// remove item from the pool
  Future<Either<Failure, void>> removeItemFromPool(Params params) {
    return repository.removeItemFromPool(params.item);
  }

  /// clear the pool
  Future<Either<Failure, void>> clearItemPool() {
    return repository.clearItemPool();
  }

  /// update item pool with the items
  Future<Either<Failure, void>> updateItemPool(ListParams listParams) {
    return repository.updateItemPool(listParams.items);
  }
}

/// Params which contains item
class Params extends Equatable {
  /// item to be passed as params into the functions
  const Params({required this.item});

  /// item to pass in params
  final Item item;

  @override
  List<Object> get props => [item];
}

/// Params which contains list items
class ListParams extends Equatable {
  /// list of items to be passed as params into the functions
  const ListParams({required this.items});

  /// list of items to pass in params
  final List<Item> items;

  @override
  List<Object> get props => [items];
}
