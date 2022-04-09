import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../entities/random_item_picked.dart';

/// random list repository which contains the methods for random list
abstract class RandomListRepository {
  /// returns a random number from the given [itemPool]
  Future<Either<Failure, RandomItemPicked>> getRandomItem(List<Item> itemPool);
}
