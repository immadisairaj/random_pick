import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';

/// abstract class for usecases,
/// implement this class to create a usecase
///
/// use the return type - [ReturnType] and params - [Params] to the class
///
/// can use [NoParams] if no params are needed
///
/// [Failure] is the type for failure that will be returned
abstract class UseCase<ReturnType, Params> {
  /// call the usecase
  Future<Either<Failure, ReturnType>> call(Params params);
}

/// can be used in [UseCase] if no params are needed
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
