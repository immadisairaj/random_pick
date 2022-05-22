import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:random_pick/core/navigation/random_pick_navigation.dart';
import 'package:random_pick/features/random/presentation/cubit/random_page_cubit.dart';
import 'package:random_pick/features/random/random_list/presentation/pages/random_list_page.dart';
import 'package:random_pick/features/random/random_number/presentation/pages/random_number_page.dart';
import 'package:random_pick/injection_container.dart';

/// the main dashboard which contains two tabs
class RandomPage extends StatelessWidget {
  /// creates a random page screen
  const RandomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RandomPageCubit>(),
      child: const RandomPageView(),
    );
  }
}

/// the main dashboard widget/page which is the main page of [RandomPage]
class RandomPageView extends StatelessWidget {
  /// builds the main page view with tabs for random page
  const RandomPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((RandomPageCubit cubit) => cubit.state.tab);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Pick'),
        actions: [
          IconButton(
            onPressed: () async {
              await PackageInfo.fromPlatform().then(
                (packageInfo) => Navigator.of(context).push(
                  MaterialPageRoute<Widget>(
                    builder: (context) => LicensePage(
                      applicationIcon:
                          Image.asset('assets/app_icon_foreground.png'),
                      applicationName: packageInfo.appName,
                      applicationVersion: packageInfo.version,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.info),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => !await Navigator.maybePop(
          getIt<RandomPickNavigation>()
              .navigatorKeys[selectedTab.index]!
              .currentState!
              .context,
        ),
        child: IndexedStack(
          index: selectedTab.index,
          children: [
            // first tab to display the random number pick
            Navigator(
              // add navigation key for nested navigation
              key: getIt<RandomPickNavigation>().navigatorKeys[0],
              onGenerateRoute: (_) => MaterialPageRoute<Widget>(
                builder: (_) => const RandomNumberPage(),
              ),
            ),
            // second tab to display the random list pick
            Navigator(
              // add navigation key for nested navigation
              key: getIt<RandomPickNavigation>().navigatorKeys[1],
              onGenerateRoute: (_) => MaterialPageRoute<Widget>(
                builder: (_) => const RandomListPage(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab.index,
        onDestinationSelected: (index) =>
            context.read<RandomPageCubit>().setTab(RandomPageTab.values[index]),
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(CupertinoIcons.number_square_fill),
            icon: Icon(CupertinoIcons.number_square),
            label: 'Numbers',
          ),
          NavigationDestination(
            selectedIcon: Icon(CupertinoIcons.square_list_fill),
            icon: Icon(CupertinoIcons.square_list),
            label: 'List',
          ),
        ],
      ),
    );
  }
}
