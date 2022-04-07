import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../data/models/number_range_model.dart';
import '../../domain/entities/number_range.dart';
import '../../domain/entities/random_number_picked.dart';
import '../../domain/repositories/random_number_repository.dart';
import '../datasources/random_number_data_source.dart';

class RandomNumberRepositoryImpl implements RandomNumberRepository {
  final RandomNumberDataSource dataSource;

  RandomNumberRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, RandomNumberPicked>> getRandomNumber(
      NumberRange numberRange) async {
    // try {
    final randomNumberPicked = await dataSource.getRandomNumber(
        NumberRangeModel(min: numberRange.min, max: numberRange.max));
    return Right(randomNumberPicked);
    // below is comment because it is already handled in the entity
    // } on ArgumentError {
    //   return Left(ArgumentFailure());
    // }
  }
}
