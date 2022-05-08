import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/navigation/random_pick_navigation.dart';
import '../../../../../injection_container.dart';
import '../../../presentation/widgets/message_display.dart';
import '../bloc/random_list_bloc.dart';
import '../widgets/random_pick_item_controller.dart';
import 'random_list_picked_page.dart';

/// Widget or Page that displays the random item pick
class RandomListPage extends StatelessWidget {
  const RandomListPage({Key? key}) : super(key: key);

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
                    return const MessageDisplay(
                      message: 'Input items to the list',
                    );
                  } else if (state.status ==
                      ItemsSubscriptionStatus.randomPickLoaded) {
                    // TODO: show the items from which it is picked
                    return Column(
                      children: [
                        MessageDisplay(
                          randomPicked: state.randomItemPicked?.itemPicked.text,
                          message: 'is the random item picked from the list',
                        ),
                        TextButton(
                          onPressed: () {
                            getIt<RandomPickNavigation>()
                                .navigatorKeys[1]!
                                .currentState!
                                .push(MaterialPageRoute(
                                    builder: (_) => RandomListPickedPage(
                                          randomItemPicked:
                                              state.randomItemPicked!,
                                        )));
                          },
                          child: const Text('View the list'),
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
            const Divider(
              height: 5,
              thickness: 5,
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
