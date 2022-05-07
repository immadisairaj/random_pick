import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/random_item_picked.dart';
import '../../domain/repositories/random_list_repository.dart';
import '../datasources/random_list_data_source.dart';
import '../models/item_model.dart';

class RandomListRepositoryImpl implements RandomListRepository {
  final RandomListDataSource dataSource;

  RandomListRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, RandomItemPicked>> getRandomItem() async {
    try {
      final randomItemPicked = await dataSource.getRandomItem();
      return Right(randomItemPicked);
    } on LengthException {
      return Left(LengthFailure());
    } on NoSelectionException {
      return Left(NoSelectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addItemToPool(Item item) async {
    return Right(await dataSource.addItemToPool(_convertItemToModel(item)));
  }

  @override
  Future<Either<Failure, void>> clearItemPool() async {
    return Right(await dataSource.clearItemPool());
  }

  @override
  Future<Either<Failure, Stream<List<Item>>>> getItemPool() async {
    final listStream = await dataSource.getItemPool();
    return Right(listStream);
  }

  @override
  Future<Either<Failure, void>> removeItemFromPool(Item item) async {
    try {
      return Right(
          await dataSource.removeItemFromPool(_convertItemToModel(item)));
    } on ItemNotFoundException {
      return Left(ItemNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateItemPool(List<Item> items) async {
    return Right(await dataSource.updateItemPool(
        items.map((item) => _convertItemToModel(item)).toList()));
  }
}

ItemModel _convertItemToModel(Item item) {
  return ItemModel(
    id: item.id,
    text: item.text,
    selected: item.selected,
  );
}

/// failure when the length of the item pool is 0 or too long
class LengthFailure extends Failure {}

/// failure when no item is selected
class NoSelectionFailure extends Failure {}

/// failure when the item is not found
class ItemNotFoundFailure extends Failure {}
