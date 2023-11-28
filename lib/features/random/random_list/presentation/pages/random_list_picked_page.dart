import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_pick/features/random/presentation/widgets/message_display.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';

/// page to display the [randomItemPicked]
class RandomListPickedPage extends StatelessWidget {
  /// creates a page to show [randomItemPicked]
  ///
  /// [isHistory] defaults to false; pass true to be able to delete from history
  const RandomListPickedPage({
    required this.randomItemPicked,
    super.key,
    this.isHistory = false,
  });

  /// the [randomItemPicked] to show
  final RandomItemPicked randomItemPicked;

  /// if the history is false, it's navigated from random list;
  /// else it's navigated from pick history
  final bool isHistory;

  Widget _listItem(BuildContext context, Item currentItem) {
    return CheckboxListTile(
      value: currentItem.selected,
      onChanged: (_) {},
      tileColor: currentItem.id == randomItemPicked.itemPicked.id
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      activeColor: Theme.of(context).colorScheme.onSurfaceVariant,
      title: Text(currentItem.text),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item list'),
        actions: [
          if (isHistory)
            IconButton(
              icon: const Icon(CupertinoIcons.delete),
              onPressed: () {
                Navigator.of(context).pop<bool>(true);
              },
            ),
        ],
      ),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: MessageDisplay(
                randomPicked: randomItemPicked.itemPicked.text,
                message: 'is the random item picked from the list',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _listItem(context, randomItemPicked.itemPool[index]),
                  childCount: randomItemPicked.itemPool.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
