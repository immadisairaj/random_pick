import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'random_page_state.dart';

class RandomPageCubit extends Cubit<RandomPageState> {
  RandomPageCubit() : super(const RandomPageState());

  void setTab(RandomPageTab tab) => emit(RandomPageState(tab: tab));
}
