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
  Future<Either<Failure, RandomItemPicked>> getRandomItem(
      List<Item> itemPool) async {
    try {
      final randomItemPicked = await dataSource.getRandomItem(
        itemPool
            .map((item) => ItemModel(
                  text: item.text,
                  selected: item.selected,
                ))
            .toList(),
      );
      return Right(randomItemPicked);
    } on LengthException {
      return Left(LengthFailure());
    } on NoSelectionException {
      return Left(NoSelectionFailure());
    }
  }
}

/// failure when the length of the item pool is 0 or too long
class LengthFailure extends Failure {}

/// failure when no item is selected
class NoSelectionFailure extends Failure {}
