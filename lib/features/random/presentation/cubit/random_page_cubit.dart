import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'random_page_state.dart';

/// Cubit for the random page indexed tabs
class RandomPageCubit extends Cubit<RandomPageState> {
  /// create a random page cubit to handle index tabs of random page
  RandomPageCubit() : super(const RandomPageState());

  /// change the page to [tab] with values from [RandomPageTab]
  void setTab(RandomPageTab tab) => emit(RandomPageState(tab: tab));
}
