import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_pick/core/navigation/random_pick_navigation.dart';
import 'package:random_pick/features/random/presentation/widgets/message_display.dart';
import 'package:random_pick/features/random/random_list/presentation/bloc/random_list_bloc.dart';
import 'package:random_pick/features/random/random_list/presentation/pages/random_list_picked_page.dart';
import 'package:random_pick/features/random/random_list/presentation/widgets/random_pick_item_controller.dart';
import 'package:random_pick/injection_container.dart';

/// Widget or Page that displays the random item pick
class RandomListPage extends StatelessWidget {
  /// creates a random list page
  const RandomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        // subscribe to items on init
        create: (_) =>
            getIt<RandomListBloc>()..add(const ItemsSubscriptionRequested()),
        child: Column(
          children: [
            Center(
              child: BlocBuilder<RandomListBloc, RandomListState>(
                builder: (context, state) {
                  if (state.status == ItemsSubscriptionStatus.itemsLoading ||
                      state.status ==
                          ItemsSubscriptionStatus.randomPickLoading) {
                    return const CircularProgressIndicator();
                  } else if (state.status ==
                      ItemsSubscriptionStatus.itemsLoaded) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: MessageDisplay(
                        message: 'Input items to the list',
                      ),
                    );
                  } else if (state.status ==
                      ItemsSubscriptionStatus.randomPickLoaded) {
                    return Column(
                      children: [
                        MessageDisplay(
                          randomPicked: state.randomItemPicked?.itemPicked.text,
                          message: 'is the random item picked from the list',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextButton(
                            onPressed: () {
                              getIt<RandomPickNavigation>()
                                  .navigatorKeys[1]!
                                  .currentState!
                                  .push(
                                    MaterialPageRoute<Widget>(
                                      builder: (_) => RandomListPickedPage(
                                        randomItemPicked:
                                            state.randomItemPicked!,
                                      ),
                                    ),
                                  );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('View the list'),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state.status == ItemsSubscriptionStatus.error) {
                    return MessageDisplay(
                      isError: true,
                      message: state.errorMessage!,
                    );
                  }
                  return const Placeholder();
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 3,
                thickness: 2,
              ),
            ),
            const Expanded(
              child: RandomPickItemController(),
            ),
          ],
        ),
      ),
    );
  }
}
