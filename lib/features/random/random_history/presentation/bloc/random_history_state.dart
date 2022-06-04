part of 'random_history_bloc.dart';

/// status of the event present in the state
enum RandomHistoryStatus {
  /// first state in the event stream
  initial,

  /// state when history is loading
  loading,

  /// state when history is completely loaded
  loaded,

  /// an error has occured
  error,
}

/// The state of the bloc
///
/// initial [status] is [RandomHistoryStatus.initial]
/// and [historyList] is empty array
///
/// all the states are distinguished by the [status] field
///
/// always use the [copyWith] method to create a new state
///
/// Note:
/// - [historyList] and [status] are mandatory
/// - make sure to provide [errorMessage] when
/// [status] is [RandomHistoryStatus.error]
class RandomHistoryState extends Equatable {
  /// creates a random list state object
  const RandomHistoryState({
    this.historyList = const [],
    this.status = RandomHistoryStatus.initial,
    this.errorMessage,
    this.lastDeletedHistory,
  });

  /// history state at the given point of the state
  ///
  /// defaults to empty
  final List<PickHistory> historyList;

  /// status of the event present in the state
  ///
  /// defaults to [RandomHistoryStatus.initial]
  final RandomHistoryStatus status;

  /// to display an error message when
  /// [status] is [RandomHistoryStatus.error]
  final String? errorMessage;

  /// store the previously deleted history item for undo
  final DeletedHistory? lastDeletedHistory;

  /// creates a new state with the copying the values from previous state
  ///
  /// provide the new values using functions
  RandomHistoryState copyWith({
    List<PickHistory> Function()? historyList,
    RandomHistoryStatus Function()? status,
    String? Function()? errorMessage,
    DeletedHistory? Function()? lastDeletedHistory,
  }) {
    return RandomHistoryState(
      historyList: historyList != null ? historyList() : this.historyList,
      status: status != null ? status() : this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      lastDeletedHistory: lastDeletedHistory != null
          ? lastDeletedHistory()
          : this.lastDeletedHistory,
    );
  }

  @override
  List<Object?> get props => [
        historyList,
        status,
        errorMessage,
        lastDeletedHistory,
      ];
}

/// deleted history to store previously deleted history
class DeletedHistory extends Equatable {
  /// creates a deleted history object
  const DeletedHistory({
    required this.index,
    required this.pickHistory,
  });

  /// index from where it is deleted
  final int index;

  /// the pick history to be deleted
  final PickHistory pickHistory;

  @override
  List<Object> get props => [index, pickHistory];
}
