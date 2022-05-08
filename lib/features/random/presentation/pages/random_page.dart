import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../random_list/presentation/pages/random_list_page.dart';
import '../../random_number/presentation/pages/random_number_page.dart';
import '../cubit/random_page_cubit.dart';

/// Random Page - the main dashboard which contains two tabs
class RandomPage extends StatelessWidget {
  /// creates a random page screen
  const RandomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RandomPageCubit>(),
      child: const RandomPageView(),
    );
  }
}

class RandomPageView extends StatelessWidget {
  const RandomPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((RandomPageCubit cubit) => cubit.state.tab);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Pick'),
      ),
      body: IndexedStack(
        index: selectedTab.index,
        children: const [
          // first tab to display the random number pick
          RandomNumberPage(),
          // second tab to display the random list pick
          RandomListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab.index,
        onTap: (index) =>
            context.read<RandomPageCubit>().setTab(RandomPageTab.values[index]),
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.number_square_fill),
            icon: Icon(CupertinoIcons.number_square),
            label: 'Numbers',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.square_list_fill),
            icon: Icon(CupertinoIcons.square_list),
            label: 'List',
          ),
        ],
      ),
    );
  }
}
