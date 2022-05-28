import 'package:flutter/material.dart';
import 'package:random_pick/features/random/random_history/domain/entities/pick_history.dart';
import 'package:random_pick/features/random/random_history/presentation/widgets/random_history_number_page.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/presentation/pages/random_list_picked_page.dart';
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

  Widget _listItem(BuildContext context, PickHistory currentHistory) {
    return ListTile(
      title: Text(_returnPickedByType(currentHistory.picked)),
      subtitle: Text(_formatDateTime(currentHistory.dateTime)),
      onTap: () {
        if (currentHistory.picked is RandomItemPicked) {
          Navigator.of(context).push(
            MaterialPageRoute<Widget>(
              builder: (context) => RandomListPickedPage(
                randomItemPicked: currentHistory.picked as RandomItemPicked,
              ),
            ),
          );
        } else if (currentHistory.picked is RandomNumberPicked) {
          Navigator.of(context).push(
            MaterialPageRoute<Widget>(
              builder: (context) => RandomHistoryNumberPage(
                randomNumberPicked: currentHistory.picked as RandomNumberPicked,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return history.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
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
