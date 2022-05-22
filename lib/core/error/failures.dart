import 'package:equatable/equatable.dart';

/// abstract class of general Failure
/// : to be extended and used for custm failure
abstract class Failure extends Equatable {
  /// creates a failure
  const Failure();

  @override
  List<Object> get props => [];
}

/// Failure which is not known
class UnknownFailure extends Failure {
  /// creates an unknown failure
  const UnknownFailure();

  @override
  List<Object> get props => [];
}
