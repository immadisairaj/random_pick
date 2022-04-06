import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/item.dart';
import '../entities/random_item_picked.dart';

abstract class RandomListRepository {
  Future<Either<Failure, RandomItemPicked>> getRandomItem(List<Item> itemsPool);
}
