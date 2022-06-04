import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:random_pick/features/random/random_history/data/models/pick_history_model.dart';
import 'package:rxdart/subjects.dart';

/// data source which can be extended to implement data sources functions
abstract class RandomHistoryDataSource {
  /// returns all history of picked
  ///
  /// the main data source of the history
  Future<Stream<List<PickHistoryModel>>> getRandomHistory();

  /// add a pick to the history;
  /// if [index] is mentioned, the history will be added at that position
  ///
  /// [index] should be no longer than length, and non-negative
  ///
  /// throws [HistoryAlreadyExistsException] if the history already exists
  Future<void> addRandomHistory(PickHistoryModel pickHistory, {int? index});

  /// get random history by pick id
  ///
  /// throws [HistoryNotFoundException] if the history is not found
  Future<PickHistoryModel> getRandomHistoryById(String id);

  /// clear the history using the history
  ///
  /// throws [HistoryNotFoundException] if the history is not found
  Future<void> clearHistory(PickHistoryModel pickHistory);

  /// clear all history
  Future<void> clearAllHistory();
}

/// implimentation of the [RandomHistoryDataSource]
class RandomHistoryDataSourceImpl implements RandomHistoryDataSource {
  /// constructor for [RandomHistoryDataSource] implementation
  RandomHistoryDataSourceImpl({required Box<String> box}) : _box = box {
    _init();
  }

  final Box<String> _box;

  final _randomHistoryStreamController =
      BehaviorSubject<List<PickHistoryModel>>.seeded(const []);

  /// The key used for storing the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  static const kHistoryKey = '__random_history_list_key__';

  Future<void> _setValue(String key, List<PickHistoryModel> history) =>
      _box.put(
        key,
        json.encode(
          history
              .map<dynamic>(
                (pickHistory) => pickHistory.toJson(),
              )
              .toList(),
        ),
      );

  void _init() {
    final historyJson = _box.get(kHistoryKey);
    if (historyJson != null) {
      final historyJsonMap = (json.decode(historyJson) as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final history = historyJsonMap
          .map<PickHistoryModel>(
            PickHistoryModel.fromJson,
          )
          .toList();
      _randomHistoryStreamController.add(history);
    } else {
      _randomHistoryStreamController.add(const []);
    }
  }

  @override
  Future<Stream<List<PickHistoryModel>>> getRandomHistory() async =>
      _randomHistoryStreamController.asBroadcastStream();

  @override
  Future<void> addRandomHistory(
    PickHistoryModel pickHistory, {
    int? index,
  }) async {
    final history = [..._randomHistoryStreamController.value];
    final historyIndex = history.indexWhere((i) => i.id == pickHistory.id);

    if (historyIndex >= 0) {
      throw HistoryAlreadyExistsException();
    } else {
      // add a history to the top of the list;
      // if [index] is mentioned, the history will be added at that position
      history.insert(index ?? 0, pickHistory);
    }

    _randomHistoryStreamController.add(history);
    return _setValue(kHistoryKey, history);
  }

  @override
  Future<PickHistoryModel> getRandomHistoryById(String id) async {
    final history = [..._randomHistoryStreamController.value];
    final historyIndex = history.indexWhere((i) => i.id == id);

    if (historyIndex >= 0) {
      return history[historyIndex];
    } else {
      throw HistoryNotFoundException();
    }
  }

  @override
  Future<void> clearAllHistory() {
    final history = <PickHistoryModel>[];
    _randomHistoryStreamController.add(history);
    return _setValue(kHistoryKey, history);
  }

  @override
  Future<void> clearHistory(PickHistoryModel pickHistory) {
    final history = [..._randomHistoryStreamController.value];
    final historyIndex = history.indexWhere((i) => i.id == pickHistory.id);

    if (historyIndex >= 0) {
      history.removeAt(historyIndex);

      _randomHistoryStreamController.add(history);
      return _setValue(kHistoryKey, history);
    } else {
      throw HistoryNotFoundException();
    }
  }
}

/// exception when history id already exists
class HistoryAlreadyExistsException implements Exception {}

/// exception when no history is found
class HistoryNotFoundException implements Exception {}
