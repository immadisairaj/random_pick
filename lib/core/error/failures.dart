import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object> get props => [];
}

// below is commented as it is not requred
// class ArgumentFailure extends Failure {}
