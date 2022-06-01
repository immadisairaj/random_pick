import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_pick/features/random/random_history/data/datasources/random_history_data_source.dart';
import 'package:random_pick/features/random/random_history/data/models/pick_history_model.dart';
import 'package:random_pick/features/random/random_number/data/models/number_range_model.dart';
import 'package:random_pick/features/random/random_number/data/models/random_number_picked_model.dart';

class MockHiveBox extends Mock implements Box<String> {}

void main() {
  late RandomHistoryDataSourceImpl dataSource;
  late MockHiveBox mockBox;

  setUp(() {
    mockBox = MockHiveBox();
    dataSource = RandomHistoryDataSourceImpl(
      box: mockBox,
    );
  });

  test('should get data from box on init', () async {
    // arrange
    final tHistoryList = <PickHistoryModel>[
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 0,
          numberRange: NumberRangeModel(min: 0, max: 0),
        ),
      ),
    ];
    final tJson = json.encode(
      tHistoryList
          .map<dynamic>(
            (pickHistory) => pickHistory.toJson(),
          )
          .toList(),
    );
    when(() => mockBox.get(RandomHistoryDataSourceImpl.kHistoryKey))
        .thenAnswer((_) => tJson);
    // act
    final resultDataSource = RandomHistoryDataSourceImpl(
      box: mockBox,
    );
    final result = await resultDataSource.getRandomHistory();
    // assert
    verify(() => mockBox.get(RandomHistoryDataSourceImpl.kHistoryKey));
    result.listen((value) {
      expect(value, equals(tHistoryList));
    });
  });

  void returnVoid() {
    return;
  }

  test('should check return value of getHistory', () async {
    // act
    final result = await dataSource.getRandomHistory();
    // assert
    verify(() => mockBox.get(RandomHistoryDataSourceImpl.kHistoryKey));
    result.listen((value) {
      expect(value, isA<List<PickHistoryModel>>());
    });
  });

  test('should check add history', () async {
    // arrange
    final tHistoryList = <PickHistoryModel>[
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 0,
          numberRange: NumberRangeModel(min: 0, max: 0),
        ),
      ),
    ];
    when(() => mockBox.put(RandomHistoryDataSourceImpl.kHistoryKey, any()))
        .thenAnswer((_) async => returnVoid());
    // act
    await dataSource.addRandomHistory(tHistoryList[0]);
    final result = await dataSource.getRandomHistory();
    // assert
    verify(
      () => mockBox.put(
        RandomHistoryDataSourceImpl.kHistoryKey,
        json.encode(
          tHistoryList.map<dynamic>((history) => history.toJson()).toList(),
        ),
      ),
    );
    result.listen((value) {
      expect(value, contains(tHistoryList[0]));
    });
  });

  test('should check add history fail', () async {
    // arrange
    final tHistoryList = <PickHistoryModel>[
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 0,
          numberRange: NumberRangeModel(min: 0, max: 0),
        ),
      ),
    ];
    when(() => mockBox.put(RandomHistoryDataSourceImpl.kHistoryKey, any()))
        .thenAnswer((_) async => returnVoid());
    // act
    await dataSource.addRandomHistory(tHistoryList[0]);
    final call = dataSource.addRandomHistory;
    // assert
    expect(
      () => call(tHistoryList[0]),
      throwsA(
        const TypeMatcher<HistoryAlreadyExistsException>(),
      ),
    );
  });

  test('should check get history by id', () async {
    // arrange
    final tHistoryList = <PickHistoryModel>[
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 0,
          numberRange: NumberRangeModel(min: 0, max: 0),
        ),
      ),
    ];
    when(() => mockBox.put(RandomHistoryDataSourceImpl.kHistoryKey, any()))
        .thenAnswer((_) async => returnVoid());
    await dataSource.addRandomHistory(tHistoryList[0]);
    // act
    final result = await dataSource.getRandomHistoryById(tHistoryList[0].id);
    // assert
    expect(result, equals(tHistoryList[0]));
  });

  test('should check get history by id failing', () async {
    // arrange
    final call = dataSource.getRandomHistoryById;
    // assert
    expect(
      () => call('something'),
      throwsA(
        const TypeMatcher<HistoryNotFoundException>(),
      ),
    );
  });

  test('should check clear all history', () async {
    // arrange
    final tHistoryList = <PickHistoryModel>[
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 0,
          numberRange: NumberRangeModel(min: 0, max: 0),
        ),
      ),
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 1,
          numberRange: NumberRangeModel(min: 1, max: 1),
        ),
      ),
    ];
    when(() => mockBox.put(RandomHistoryDataSourceImpl.kHistoryKey, any()))
        .thenAnswer((_) async => returnVoid());
    await dataSource.addRandomHistory(tHistoryList[0]);
    await dataSource.addRandomHistory(tHistoryList[1]);
    // act
    await dataSource.clearAllHistory();
    final result = await dataSource.getRandomHistory();
    // assert
    verify(
      () => mockBox.put(
        RandomHistoryDataSourceImpl.kHistoryKey,
        json.encode(
          <PickHistoryModel>[]
              .map<dynamic>((history) => history.toJson())
              .toList(),
        ),
      ),
    );
    result.listen((value) {
      expect(value, isNot(contains(tHistoryList[0])));
      expect(value, isNot(contains(tHistoryList[1])));
    });
  });

  test('should check clear all history when no data is there', () async {
    // arrange
    final tHistoryList = <PickHistoryModel>[
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 0,
          numberRange: NumberRangeModel(min: 0, max: 0),
        ),
      ),
    ];
    when(() => mockBox.put(RandomHistoryDataSourceImpl.kHistoryKey, any()))
        .thenAnswer((_) async => returnVoid());
    // act
    await dataSource.clearAllHistory();
    final result = await dataSource.getRandomHistory();
    // assert
    verify(
      () => mockBox.put(
        RandomHistoryDataSourceImpl.kHistoryKey,
        json.encode(
          <PickHistoryModel>[]
              .map<dynamic>((history) => history.toJson())
              .toList(),
        ),
      ),
    );
    result.listen((value) {
      expect(value, isNot(contains(tHistoryList[0])));
    });
  });

  test('should check clear history by id', () async {
    // arrange
    final tHistoryList = <PickHistoryModel>[
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 0,
          numberRange: NumberRangeModel(min: 0, max: 0),
        ),
      ),
      PickHistoryModel(
        dateTime: DateTime.now(),
        picked: RandomNumberPickedModel(
          randomNumber: 1,
          numberRange: NumberRangeModel(min: 1, max: 1),
        ),
      ),
    ];
    final tHistoryResult = [
      tHistoryList[1],
    ];
    when(() => mockBox.put(RandomHistoryDataSourceImpl.kHistoryKey, any()))
        .thenAnswer((_) async => returnVoid());
    await dataSource.addRandomHistory(tHistoryList[0]);
    await dataSource.addRandomHistory(tHistoryList[1]);
    // act
    await dataSource.clearHistoryById(tHistoryList[0].id);
    final result = await dataSource.getRandomHistory();
    // assert
    verify(
      () => mockBox.put(
        RandomHistoryDataSourceImpl.kHistoryKey,
        json.encode(
          tHistoryResult.map<dynamic>((history) => history.toJson()).toList(),
        ),
      ),
    );
    result.listen((value) {
      expect(value, isNot(contains(tHistoryList[0])));
      expect(value, contains(tHistoryList[1]));
    });
  });

  test('should check clear history by id failing', () async {
    // arrange
    final call = dataSource.clearHistoryById;
    // assert
    expect(
      () => call('something'),
      throwsA(
        const TypeMatcher<HistoryNotFoundException>(),
      ),
    );
  });
}
