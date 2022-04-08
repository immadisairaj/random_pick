import 'package:flutter_test/flutter_test.dart';
import 'package:random_pick/features/random/presentation/cubit/random_page_cubit.dart';

void main() {
  late RandomPageCubit cubit;

  setUp(() {
    cubit = RandomPageCubit();
  });

  test('state should be RandomPageState', () {
    expect(cubit.state, equals(const RandomPageState()));
  });

  group('tab check', () {
    test('should emit RandomPageState number by default', () {
      // assert
      expect(cubit.state,
          equals(const RandomPageState(tab: RandomPageTab.number)));
    });
    test('should emit RandomPageState with tab list', () {
      // act
      cubit.setTab(RandomPageTab.list);
      // assert
      expect(
          cubit.state, equals(const RandomPageState(tab: RandomPageTab.list)));
    });
    test('should emit RandomPageState with tab number', () {
      // act
      cubit.setTab(RandomPageTab.number);
      // assert
      expect(cubit.state,
          equals(const RandomPageState(tab: RandomPageTab.number)));
    });
  });
}
