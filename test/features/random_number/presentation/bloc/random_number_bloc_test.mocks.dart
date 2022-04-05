// Mocks generated by Mockito 5.1.0 from annotations
// in random_pick/test/features/random_number/presentation/bloc/random_number_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:random_pick/core/error/failures.dart' as _i6;
import 'package:random_pick/core/utils/input_converter.dart' as _i8;
import 'package:random_pick/features/random_number/domain/entities/number_range.dart'
    as _i9;
import 'package:random_pick/features/random_number/domain/entities/random_number_picked.dart'
    as _i7;
import 'package:random_pick/features/random_number/domain/repositories/random_number_repository.dart'
    as _i2;
import 'package:random_pick/features/random_number/domain/usecases/get_random_number.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeRandomNumberRepository_0 extends _i1.Fake
    implements _i2.RandomNumberRepository {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [GetRandomNumber].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRandomNumber extends _i1.Mock implements _i4.GetRandomNumber {
  MockGetRandomNumber() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RandomNumberRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
              returnValue: _FakeRandomNumberRepository_0())
          as _i2.RandomNumberRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.RandomNumberPicked>> call(
          _i4.Params? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i6.Failure, _i7.RandomNumberPicked>>.value(
                      _FakeEither_1<_i6.Failure, _i7.RandomNumberPicked>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i7.RandomNumberPicked>>);
}

/// A class which mocks [InputConverter].
///
/// See the documentation for Mockito's code generation for more information.
class MockInputConverter extends _i1.Mock implements _i8.InputConverter {
  MockInputConverter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Either<_i6.Failure, _i9.NumberRange> stringsToNumberRange(
          String? min, String? max) =>
      (super.noSuchMethod(Invocation.method(#stringsToNumberRange, [min, max]),
              returnValue: _FakeEither_1<_i6.Failure, _i9.NumberRange>())
          as _i3.Either<_i6.Failure, _i9.NumberRange>);
}
