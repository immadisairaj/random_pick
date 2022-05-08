import 'package:equatable/equatable.dart';

/// abstract class of general Failure
/// : to be extended and used for custm failure
abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object> get props => [];
}

/// Failure which is not known
class UnknownFailure extends Failure {
  const UnknownFailure();
  @override
  List<Object> get props => [];
}
