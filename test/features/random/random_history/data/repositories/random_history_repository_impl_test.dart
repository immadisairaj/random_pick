import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/features/random/random_history/data/datasources/random_history_data_source.dart';
import 'package:random_pick/features/random/random_history/data/models/pick_history_model.dart';
import 'package:random_pick/features/random/random_history/data/repositories/random_history_repository_impl.dart';
import 'package:random_pick/features/random/random_number/domain/entities/number_range.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

class MockRandomHistoryDataSource extends Mock
    implements RandomHistoryDataSource {}

void main() {
  late RandomHistoryRepositoryImpl repository;
  late MockRandomHistoryDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRandomHistoryDataSource();
    repository = RandomHistoryRepositoryImpl(
      dataSource: mockDataSource,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPicked(
          randomNumber: 0,
          numberRange: NumberRange(max: 0),
        ),
      ),
    );
  });

  void returnVoid() {
    return;
  }

  test(
    'should return stream from getRandomHistory',
    () async {
      // arrange
      final tController = StreamController<List<PickHistoryModel>>();
      final tStream = tController.stream;

      when(() => mockDataSource.getRandomHistory())
          .thenAnswer((_) async => tStream);
      // act
      final result = await repository.getRandomHistory();
      // assert
      verify(() => mockDataSource.getRandomHistory());
      expect(
        result,
        equals(Right<dynamic, Stream<List<PickHistoryModel>>>(tStream)),
      );
    },
  );

  test(
    'should verify if add pick to history',
    () async {
      // arrange
      final tPickHistory = PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPicked(
          randomNumber: 0,
          numberRange: NumberRange(max: 0),
        ),
      );

      when(() => mockDataSource.addRandomHistory(any()))
          .thenAnswer((_) async => returnVoid());
      // act
      final result = await repository.putRandomHistory(tPickHistory);
      // assert
      verify(() => mockDataSource.addRandomHistory(tPickHistory));
      expect(result, equals(Right<dynamic, void>(returnVoid())));
    },
  );

  test(
    'should fail if add pick to history which already exists',
    () async {
      // arrange
      final tPickHistory = PickHistoryModel(
        id: '1',
        dateTime: DateTime.now(),
        picked: RandomNumberPicked(
          randomNumber: 0,
          numberRange: NumberRange(max: 0),
        ),
      );

      when(() => mockDataSource.addRandomHistory(any()))
          .thenThrow(HistoryAlreadyExistsException());
      // act
      final result = await repository.putRandomHistory(tPickHistory);
      // assert
      verify(() => mockDataSource.addRandomHistory(tPickHistory));
      expect(
        result,
        equals(
          Left<HistoryAlreadyExistsFailure, dynamic>(
            HistoryAlreadyExistsFailure(),
          ),
        ),
      );
    },
  );

  test(
    'should verify if get pick history by id',
    () async {
      // arrange
      final tPickHistory = PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPicked(
          randomNumber: 0,
          numberRange: NumberRange(max: 0),
        ),
      );

      when(() => mockDataSource.getRandomHistoryById(any()))
          .thenAnswer((_) async => tPickHistory);
      // act
      final result = await repository.getRandomHistoryById(tPickHistory.id);
      // assert
      verify(() => mockDataSource.getRandomHistoryById(tPickHistory.id));
      expect(result, equals(Right<dynamic, PickHistoryModel>(tPickHistory)));
    },
  );

  test(
    'should fail if get pick history by id does not exist',
    () async {
      // arrange
      final tPickHistory = PickHistoryModel(
        id: '1',
        dateTime: DateTime.now(),
        picked: RandomNumberPicked(
          randomNumber: 0,
          numberRange: NumberRange(max: 0),
        ),
      );

      when(() => mockDataSource.getRandomHistoryById(any()))
          .thenThrow(HistoryNotFoundException());
      // act
      final result = await repository.getRandomHistoryById(tPickHistory.id);
      // assert
      verify(() => mockDataSource.getRandomHistoryById(tPickHistory.id));
      expect(
        result,
        equals(
          Left<HistoryNotFoundFailure, dynamic>(
            HistoryNotFoundFailure(),
          ),
        ),
      );
    },
  );
}
