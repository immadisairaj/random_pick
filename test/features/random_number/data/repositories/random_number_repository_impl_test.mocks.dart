// Mocks generated by Mockito 5.1.0 from annotations
// in random_pick/test/features/random_number/data/repositories/random_number_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:random_pick/features/random_number/data/datasources/random_number_data_source.dart'
    as _i2;
import 'package:random_pick/features/random_number/data/models/number_range_model.dart'
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

/// A class which mocks [RandomNumberDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockRandomNumberDataSource extends _i1.Mock
    implements _i2.RandomNumberDataSource {
  MockRandomNumberDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<int> getRandomNumber(_i4.NumberRangeModel? numberRange) =>
      (super.noSuchMethod(Invocation.method(#getRandomNumber, [numberRange]),
          returnValue: Future<int>.value(0)) as _i3.Future<int>);
}
