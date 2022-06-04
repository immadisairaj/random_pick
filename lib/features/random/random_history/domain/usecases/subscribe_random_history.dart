import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:random_pick/core/error/failures.dart';
import 'package:random_pick/core/usecases/usecase.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/domain/repositories/random_history_repository.dart';

/// usecase class to get random number by taking
/// [NoParams]
class SubscribeRandomHistory
    implements UseCase<Stream<List<PickHistory>>, NoParams> {
  /// subscribe to the history, gets all history
  SubscribeRandomHistory(this.repository);

  /// repository for subscribing to the history and make operations
  final RandomHistoryRepository repository;

  /// get all history from repository
  @override
  Future<Either<Failure, Stream<List<PickHistory>>>> call(NoParams params) {
    return repository.getRandomHistory();
  }

  /// get history by id from repository
  Future<Either<Failure, PickHistory>> getRandomHistoryById(IdParams params) {
    return repository.getRandomHistoryById(params.id);
  }

  /// put history in the repository;
  /// put in index, if index is specified
  Future<Either<Failure, void>> putRandomHistory(HistoryParams params) {
    return repository.putRandomHistory(params.pickHistory, index: params.index);
  }

  /// clear all history from repository
  Future<Either<Failure, void>> clearAllHistory(NoParams params) {
    return repository.clearAllHistory();
  }

  /// clear history of the pick history from repository
  Future<Either<Failure, void>> clearHistory(HistoryParams params) {
    return repository.clearHistory(params.pickHistory);
  }
}

/// Params which contains [pickHistory] and optional [index]
class HistoryParams extends Equatable {
  /// pick history to be passed as params into the functions
  const HistoryParams({required this.pickHistory, this.index});

  /// pick history to pass in params
  final PickHistory pickHistory;

  /// index to where the history should be inserted (if add)
  final int? index;

  @override
  List<Object?> get props => [pickHistory, index];
}

/// Params which contains id for pick history
class IdParams extends Equatable {
  /// id to be passed as params into the functions
  const IdParams({required this.id});

  /// id to pass in params
  final String id;

  @override
  List<Object> get props => [id];
}
