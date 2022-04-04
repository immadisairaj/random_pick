import 'package:dartz/dartz.dart';
import 'package:random_pick/features/random_number/data/models/number_range_model.dart';

import '../datasources/random_number_data_source.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/number_range.dart';
import '../../domain/repositories/random_number_repository.dart';

class RandomNumberRepositoryImpl implements RandomNumberRepository {
  final RandomNumberDataSource dataSource;

  RandomNumberRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, int>> getRandomNumber(NumberRange numberRange) async {
    // try {
    final randomNumber = await dataSource.getRandomNumber(
        NumberRangeModel(min: numberRange.min, max: numberRange.max));
    return Right(randomNumber);
    // below is comment because it is already handled in the entity
    // } on ArgumentError {
    //   return Left(ArgumentFailure());
    // }
  }
}
