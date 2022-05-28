import 'package:flutter/material.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

/// widget to display the history of pick by taking the parameter
/// [history]
class RandomHistoryListView extends StatelessWidget {
  /// creates a random history list view
  const RandomHistoryListView({super.key, required this.history});

  /// the history to display
  final List<PickHistory> history;

  String _returnPickedByType(dynamic picked) {
    if (picked is RandomNumberPicked) {
      return picked.randomNumber.toString();
    } else if (picked is RandomItemPicked) {
      return picked.itemPicked.text;
    }
    return 'Error Text';
  }

  Widget _listItem(BuildContext context, PickHistory currentHistory) {
    return ListTile(
      title: Text(_returnPickedByType(currentHistory.picked)),
      subtitle: Text(currentHistory.dateTime.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return history.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _listItem(context, history[index]),
                    childCount: history.length,
                  ),
                ),
              ),
            ],
          )
        : const Text('No history to display');
  }
}
