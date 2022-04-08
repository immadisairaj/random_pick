part of 'random_page_cubit.dart';

enum RandomPageTab { number, list }

class RandomPageState extends Equatable {
  final RandomPageTab tab;

  const RandomPageState({
    this.tab = RandomPageTab.number,
  });

  @override
  List<Object> get props => [tab];
}
