// Mocks generated by Mockito 5.1.0 from annotations
// in random_pick/test/features/random/random_list/domain/usecases/subscribe_items_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:random_pick/core/error/failures.dart' as _i5;
import 'package:random_pick/features/random/random_list/domain/entities/item.dart'
    as _i7;
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart'
    as _i6;
import 'package:random_pick/features/random/random_list/domain/repositories/random_list_repository.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [RandomListRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockRandomListRepository extends _i1.Mock
    implements _i3.RandomListRepository {
  MockRandomListRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.RandomItemPicked>> getRandomItem() =>
      (super.noSuchMethod(Invocation.method(#getRandomItem, []),
              returnValue:
                  Future<_i2.Either<_i5.Failure, _i6.RandomItemPicked>>.value(
                      _FakeEither_0<_i5.Failure, _i6.RandomItemPicked>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.RandomItemPicked>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i4.Stream<List<_i7.Item>>>>
      getItemPool() => (super.noSuchMethod(Invocation.method(#getItemPool, []),
          returnValue: Future<
                  _i2.Either<_i5.Failure, _i4.Stream<List<_i7.Item>>>>.value(
              _FakeEither_0<_i5.Failure, _i4.Stream<List<_i7.Item>>>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i4.Stream<List<_i7.Item>>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> addItemToPool(_i7.Item? item) =>
      (super.noSuchMethod(Invocation.method(#addItemToPool, [item]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_0<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> removeItemFromPool(
          _i7.Item? item) =>
      (super.noSuchMethod(Invocation.method(#removeItemFromPool, [item]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_0<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> clearItemPool() =>
      (super.noSuchMethod(Invocation.method(#clearItemPool, []),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_0<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> updateItemPool(
          List<_i7.Item>? items) =>
      (super.noSuchMethod(Invocation.method(#updateItemPool, [items]),
              returnValue: Future<_i2.Either<_i5.Failure, void>>.value(
                  _FakeEither_0<_i5.Failure, void>()))
          as _i4.Future<_i2.Either<_i5.Failure, void>>);
}
