part of 'random_history_bloc.dart';

/// abstract class event for the random history bloc
abstract class RandomHistoryEvent extends Equatable {
  /// creates a random history event
  const RandomHistoryEvent();

  @override
  List<Object> get props => [];
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
class ClearHistoryRequested extends RandomHistoryEvent {
  /// create a new [ClearHistoryRequested]
  const ClearHistoryRequested();
}

/// dispatch this event to clear history by id
class ClearHistoryByIdRequested extends RandomHistoryEvent {
  /// create a new [ClearHistoryByIdRequested] with [id]
  /// of history to be removed
  const ClearHistoryByIdRequested({required this.id});

  /// the pick history to be added
  final String id;

  @override
  List<Object> get props => [id];
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
