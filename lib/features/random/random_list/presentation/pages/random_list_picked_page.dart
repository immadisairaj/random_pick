import 'package:flutter/material.dart';

import '../../../presentation/widgets/message_display.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/random_item_picked.dart';

class RandomListPickedPage extends StatelessWidget {
  const RandomListPickedPage({
    Key? key,
    required this.randomItemPicked,
  }) : super(key: key);

  final RandomItemPicked randomItemPicked;

  Widget _listItem(BuildContext context, Item currentItem) {
    return CheckboxListTile(
      value: currentItem.selected,
      onChanged: (_) {},
      tileColor: currentItem.id == randomItemPicked.itemPicked.id
          ? Theme.of(context).colorScheme.surfaceVariant
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
