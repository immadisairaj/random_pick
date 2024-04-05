import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_pick/features/random/presentation/cubit/random_page_cubit.dart';
import 'package:random_pick/features/random/random_list/data/models/item_model.dart';
import 'package:random_pick/features/random/random_list/domain/entities/random_item_picked.dart';
import 'package:random_pick/features/random/random_list/presentation/bloc/random_list_bloc.dart';

/// A Helper class for Random List feature
class RandomListHelper {
  /// Helps to re-pick the picked list. It navigates to the root and then,
  /// to the list view - auto populates the list using [picked].
  ///
  /// [context] is the current context from where the method is called
  /// [picked] is the [RandomItemPicked] to re-pick
  /// [uncheckPicked] is a flag to uncheck the picked item from the pool
  static void rePick(
    BuildContext context,
    RandomItemPicked picked, {
    bool uncheckPicked = false,
  }) {
    final itemPool = [...picked.itemPool];
    // uncheck the picked item from the pool if the flag is true
    if (uncheckPicked) {
      final itemIndex =
          itemPool.indexWhere((i) => i.id == picked.itemPicked.id);
      itemPool.replaceRange(
        itemIndex,
        itemIndex + 1,
        [itemPool[itemIndex].copyWith(selected: false) as ItemModel],
      );
    }
    // Update the list of items in the pool
    BlocProvider.of<RandomListBloc>(context).add(
      ItemsUpdateRequested(
        items: itemPool,
      ),
    );
    // Pop till the first route
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.read<RandomPageCubit>().setTab(RandomPageTab.list);
  }
}
