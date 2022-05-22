import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';

/// random list repository which contains the methods for random list
abstract class RandomListRepository {
  /// returns a random number from the given
  Future<Either<Failure, RandomItemPicked>> getRandomItem();

  /// returns a random pool of items
  Future<Either<Failure, Stream<List<Item>>>> getItemPool();

  /// add item to the pool
  Future<Either<Failure, void>> addItemToPool(Item item);

  /// remove item from the pool
  Future<Either<Failure, void>> removeItemFromPool(Item item);

  /// clear the pool
  Future<Either<Failure, void>> clearItemPool();

  /// update item pool with the items
  Future<Either<Failure, void>> updateItemPool(List<Item> items);
}
