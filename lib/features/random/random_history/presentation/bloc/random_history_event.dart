part of 'random_history_bloc.dart';

/// abstract class event for the random history bloc
abstract class RandomHistoryEvent extends Equatable {
  /// creates a random history event
  const RandomHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// dispatch this event to subscribe to the history
class HistorySubscriptionRequested extends RandomHistoryEvent {
  /// subscribe to the history
  const HistorySubscriptionRequested();
}

/// dispatch this event to add a pick in the history
class HistoryAddRequested extends RandomHistoryEvent {
  /// create a new [HistoryAddRequested] with the [pickHistory] to be added
  const HistoryAddRequested({required this.pickHistory});

  /// the pick history to be added
  final PickHistory pickHistory;

  @override
  List<Object> get props => [pickHistory];
}

/// dispatch this event to clear history
class ClearAllHistoryRequested extends RandomHistoryEvent {
  /// create a new [ClearAllHistoryRequested]
  const ClearAllHistoryRequested();
}

/// dispatch this event to clear history using [pickHistory]
class ClearHistoryRequested extends RandomHistoryEvent {
  /// create a new [ClearHistoryRequested] with [pickHistory]
  /// of history to be removed
  ///
  /// if [index] is passed, the undo operation can be done, else no
  const ClearHistoryRequested({required this.pickHistory, this.index});

  /// the pick history to be added
  final PickHistory pickHistory;

  /// the index of the history to be removed
  final int? index;

  @override
  List<Object?> get props => [pickHistory, index];
}

/// dispatch this event to undo clear history by id
class ClearHistoryUndoRequested extends RandomHistoryEvent {
  /// create a new [ClearHistoryUndoRequested]
  const ClearHistoryUndoRequested();
}

// /// dispatch this event to get a pick in the history by [id]
// class GetHistoryByIdRequested extends RandomHistoryEvent {
//   /// create a new [GetHistoryByIdRequested] with the [id]
//   /// to get the pick history
//   const GetHistoryByIdRequested({required this.id});

//   /// the id of the pick history to be retrieved
//   final String id;

//   @override
//   List<Object> get props => [id];
// }
