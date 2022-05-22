part of 'random_page_cubit.dart';

/// list of tabs in the random page
enum RandomPageTab {
  /// the tab for the random number page
  number,

  /// the tab for the random list page
  list,
}

/// only state for the random page to represent
/// which tab is selected
class RandomPageState extends Equatable {
  /// creates a random page state.
  ///
  /// defaults to [RandomPageTab.number]
  const RandomPageState({
    this.tab = RandomPageTab.number,
  });

  /// the tab selected
  final RandomPageTab tab;

  @override
  List<Object> get props => [tab];
}
