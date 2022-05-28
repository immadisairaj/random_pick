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

  /// add a pick to the history
  Future<void> addRandomHistory(PickHistoryModel pickHistory);

  /// get random history by pick id
  Future<PickHistoryModel> getRandomHistoryById(String id);
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
  Future<void> addRandomHistory(PickHistoryModel pickHistory) async {
    final history = [..._randomHistoryStreamController.value];
    final historyIndex = history.indexWhere((i) => i.id == pickHistory.id);
    if (historyIndex >= 0) {
      throw HistoryAlreadyExistsException();
    } else {
      // always add a history to the top of the list
      history.insert(0, pickHistory);
    }

    _randomHistoryStreamController.add(history);
    return _box.put(
      kHistoryKey,
      json.encode(
        history
            .map<dynamic>(
              (pickHistory) => pickHistory.toJson(),
            )
            .toList(),
      ),
    );
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
}

/// exception when history id already exists
class HistoryAlreadyExistsException implements Exception {}

/// exception when no history is found
class HistoryNotFoundException implements Exception {}
