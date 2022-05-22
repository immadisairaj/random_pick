import 'package:dartz/dartz.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/features/random/random_number/data/datasources/random_number_data_source.dart';
import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';
import 'package:random_pick/features/random/random_number/domain/repositories/random_number_repository.dart';

/// Implementation for [RandomNumberRepository]
class RandomNumberRepositoryImpl implements RandomNumberRepository {
  /// constructor for [RandomNumberRepository] implementation which provides
  /// functions for the use of Random Number
  RandomNumberRepositoryImpl({
    required this.dataSource,
  });

  /// data source for random number pick
  final RandomNumberDataSource dataSource;

  @override
  Future<Either<Failure, RandomNumberPicked>> getRandomNumber(
    NumberRange numberRange,
  ) async {
    // try {
    final randomNumberPicked = await dataSource.getRandomNumber(
      NumberRangeModel(min: numberRange.min, max: numberRange.max),
    );
    return Right(randomNumberPicked);
    // below is comment because it is already handled in the entity
    // } on ArgumentError {
    //   return Left(ArgumentFailure());
    // }
  }
}
