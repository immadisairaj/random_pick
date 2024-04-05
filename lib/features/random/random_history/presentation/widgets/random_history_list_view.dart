import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/presentation/bloc/random_history_bloc.dart';
import 'package:random_pick/features/random/random_history/presentation/widgets/random_history_number_page.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/helpers/random_list_helper.dart';
import 'package:random_pick/features/random/random_list/presentation/pages/random_list_picked_page.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

/// widget to display the history of pick by taking the parameter
/// [history]
class RandomHistoryListView extends StatelessWidget {
  /// creates a random history list view
  const RandomHistoryListView({required this.history, super.key});

  /// the history to display
  final List<PickHistory> history;

  String _returnPickedByType(dynamic picked) {
    if (picked is RandomNumberPicked) {
      return 'Picked Number: ${picked.randomNumber}';
    } else if (picked is RandomItemPicked) {
      return 'Picked Item: ${picked.itemPicked.text}';
    }
    return 'Error Text';
  }

  String _formatDateTime(DateTime dateTime) {
    return 'Date: ${dateTime.day}-${dateTime.month}-${dateTime.year}\t\t'
        'Time: ${dateTime.hour}:${dateTime.minute}';
  }

  Widget _listItem(
    BuildContext context,
    PickHistory currentHistory,
    int index,
  ) {
    return ListTile(
      title: Text(_returnPickedByType(currentHistory.picked)),
      subtitle: Text(_formatDateTime(currentHistory.dateTime)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // option to re-pick from a list of items
          if (currentHistory.picked is RandomItemPicked)
            IconButton(
              icon: const Icon(CupertinoIcons.arrow_2_circlepath),
              tooltip: 'Repick',
              splashRadius: 24,
              onPressed: () => RandomListHelper.rePick(
                context,
                currentHistory.picked as RandomItemPicked,
              ),
            ),
          IconButton(
            icon: const Icon(CupertinoIcons.delete),
            tooltip: 'Delete',
            splashRadius: 24,
            onPressed: () {
              // delete history
              BlocProvider.of<RandomHistoryBloc>(context).add(
                ClearHistoryRequested(
                  pickHistory: currentHistory,
                  index: index,
                ),
              );
            },
          ),
        ],
      ),
      onTap: () {
        if (currentHistory.picked is RandomItemPicked) {
          Navigator.of(context)
              .push<bool>(
            MaterialPageRoute(
              builder: (context) => RandomListPickedPage(
                randomItemPicked: currentHistory.picked as RandomItemPicked,
                isHistory: true,
              ),
            ),
          )
              .then((value) {
            if (value != null && value) {
              // delete history
              BlocProvider.of<RandomHistoryBloc>(context).add(
                ClearHistoryRequested(
                  pickHistory: currentHistory,
                  index: index,
                ),
              );
            }
          });
        } else if (currentHistory.picked is RandomNumberPicked) {
          Navigator.of(context)
              .push<bool>(
            MaterialPageRoute(
              builder: (context) => RandomHistoryNumberPage(
                randomNumberPicked: currentHistory.picked as RandomNumberPicked,
                isHistory: true,
              ),
            ),
          )
              .then((value) {
            if (value != null && value) {
              // delete history
              BlocProvider.of<RandomHistoryBloc>(context).add(
                ClearHistoryRequested(
                  pickHistory: currentHistory,
                  index: index,
                ),
              );
            }
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RandomHistoryBloc, RandomHistoryState>(
      listenWhen: (previous, current) =>
          previous.lastDeletedHistory != current.lastDeletedHistory &&
          current.lastDeletedHistory != null,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: const Text('Deleted History!'),
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  context
                      .read<RandomHistoryBloc>()
                      .add(const ClearHistoryUndoRequested());
                },
              ),
            ),
          );
      },
      child: history.isNotEmpty
          ? Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _listItem(context, history[index], index),
                          childCount: history.length,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                      onPressed: () => _showMyDialog(context: context),
                      child: const Text('Clear History'),
                    ),
                  ),
                ),
              ],
            )
          : const Text('No history to display'),
    );
  }

  Future<void> _showMyDialog({required BuildContext context}) async {
    // this contextS is the context save to clear the pick history
    final contextS = context;
    return showAdaptiveDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This will clear all the pick history.'),
                Text('Would you like to clear?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () {
                // clear all history
                BlocProvider.of<RandomHistoryBloc>(contextS)
                    .add(const ClearAllHistoryRequested());

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
