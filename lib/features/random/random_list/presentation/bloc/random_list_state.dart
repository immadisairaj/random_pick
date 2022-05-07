part of 'random_list_bloc.dart';

// abstract class RandomListState extends Equatable {
//   const RandomListState();

//   @override
//   List<Object> get props => [];
// }

enum ItemsSubscriptionStatus {
  initial,
  loading,
  loaded,
}

class RandomListState extends Equatable {
  final List<Item> itemPool;
  final ItemsSubscriptionStatus status;

  const RandomListState({
    this.itemPool = const [],
    this.status = ItemsSubscriptionStatus.initial,
  });

  RandomListState copyWith({
    List<Item> Function()? itemPool,
    ItemsSubscriptionStatus Function()? status,
  }) {
    return RandomListState(
      itemPool: itemPool != null ? itemPool() : this.itemPool,
      status: status != null ? status() : this.status,
    );
  }

  @override
  List<Object> get props => [
        itemPool,
        status,
      ];
}

/// state when random item pick is loading
class RandomListPickLoading extends RandomListState {}

/// state when the random item pick is successful
///
/// [randomItemPicked] contains the picked and item pool
class RandomListPickLoaded extends RandomListState {
  final RandomItemPicked randomItemPicked;

  const RandomListPickLoaded({required this.randomItemPicked});

  @override
  List<Object> get props => [randomItemPicked];
}

/// state when the random item pick is unsuccessful
///
/// provides an [errorMessage] of why it is unsuccessful
class RandomListError extends RandomListState {
  final String errorMessage;

  const RandomListError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
