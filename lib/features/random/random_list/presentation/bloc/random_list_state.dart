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

class RandomListState extends Equatable {
  final List<Item> itemPool;
  final ItemsSubscriptionStatus status;
  final String? errorMessage;
  final RandomItemPicked? randomItemPicked;

  const RandomListState({
    this.itemPool = const [],
    this.status = ItemsSubscriptionStatus.initial,
    this.errorMessage,
    this.randomItemPicked,
  });

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
