part of 'random_list_bloc.dart';

/// status of the event present in the state
///
/// - initial: the first state in the event stream
/// - error: an error has occurred
/// - itemsLoading: the state when the items are being loaded
/// - itemsLoaded: the state when the items are loaded
/// - randomPickLoading: the state when the random item is being picked
/// - randomPickLoaded: the state when the random item is picked
enum ItemsSubscriptionStatus {
  initial,
  error,
  itemsLoading,
  itemsLoaded,
  randomPickLoading,
  randomPickLoaded,
}

/// The state of the bloc
///
/// initial [status] is [ItemsSubscriptionStatus.initial]
/// and [itemPool] is empty array
///
/// all the states are distinguished by the [status] field
///
/// always use the [copyWith] method to create a new state
///
/// Note:
/// - [itemPool] and [status] are mandatory
/// - make sure to provide [errorMessage] when
/// [status] is [ItemsSubscriptionStatus.error]
/// - make sure to provide [randomItemPicked] when
/// [status] is [ItemsSubscriptionStatus.randomPickLoaded]
class RandomListState extends Equatable {
  /// itemPool at the given point of state
  ///
  /// defaults to empty array
  final List<Item> itemPool;

  /// status of the event present in the state
  ///
  /// defaults to [ItemsSubscriptionStatus.initial]
  final ItemsSubscriptionStatus status;

  /// to display an error message when
  /// [status] is [ItemsSubscriptionStatus.error]
  final String? errorMessage;

  /// the random item picked when
  /// [status] is [ItemsSubscriptionStatus.randomPickLoaded]
  final RandomItemPicked? randomItemPicked;

  /// creates a random list state object
  const RandomListState({
    this.itemPool = const [],
    this.status = ItemsSubscriptionStatus.initial,
    this.errorMessage,
    this.randomItemPicked,
  });

  /// creates a new state with the copying the values from previous state
  ///
  /// provide the new values using functions
  RandomListState copyWith({
    List<Item> Function()? itemPool,
    ItemsSubscriptionStatus Function()? status,
    String? Function()? errorMessage,
    RandomItemPicked? Function()? randomItemPicked,
  }) {
    return RandomListState(
      itemPool: itemPool != null ? itemPool() : this.itemPool,
      status: status != null ? status() : this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      randomItemPicked:
          randomItemPicked != null ? randomItemPicked() : this.randomItemPicked,
    );
  }

  @override
  List<Object> get props => [
        itemPool,
        status,
      ];
}

// /// state when random item pick is loading
// class RandomListPickLoading extends RandomListState {}

// /// state when the random item pick is successful
// ///
// /// [randomItemPicked] contains the picked and item pool
// class RandomListPickLoaded extends RandomListState {
//   final RandomItemPicked randomItemPicked;

//   const RandomListPickLoaded({required this.randomItemPicked});

//   @override
//   List<Object> get props => [randomItemPicked];
// }

// /// state when the random item pick is unsuccessful
// ///
// /// provides an [errorMessage] of why it is unsuccessful
// class RandomListError extends RandomListState {
//   final String errorMessage;

//   const RandomListError({required this.errorMessage});

//   @override
//   List<Object> get props => [errorMessage];
// }
