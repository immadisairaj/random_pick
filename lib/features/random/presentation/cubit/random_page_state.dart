part of 'random_page_cubit.dart';

/// list of tabs in the random page
enum RandomPageTab { number, list }

/// only state for the random page to represent
/// which tab is selected
class RandomPageState extends Equatable {
  final RandomPageTab tab;

  const RandomPageState({
    this.tab = RandomPageTab.number,
  });

  @override
  List<Object> get props => [tab];
}
