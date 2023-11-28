import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_pick/core/utils/constants.dart';
import 'package:random_pick/features/random/random_list/domain/entities/item.dart';
import 'package:random_pick/features/random/random_list/presentation/bloc/random_list_bloc.dart';

/// Controller widget for random list
///
/// - contains dynamic list of items (text fields)
/// - adds new items to the list
/// - removes items from the list
/// - edits items from the list
/// - dispatches the random item pick event
class RandomPickItemController extends StatefulWidget {
  /// creates a controller for random list
  const RandomPickItemController({
    super.key,
  });

  @override
  State<RandomPickItemController> createState() =>
      _RandomPickItemControllerState();
}

class _RandomPickItemControllerState extends State<RandomPickItemController> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _singleTextField(List<Item> items, int index) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        key: Key(items[index].id),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.circularRadius),
            ),
          ),
          hintText: 'Input Item',
          prefixIcon: Checkbox(
            value: items[index].selected,
            // edit the item using add event to select/deselect
            onChanged: (value) => BlocProvider.of<RandomListBloc>(context).add(
              ItemAddRequested(
                item: items[index].copyWith(
                  selected: value,
                ),
              ),
            ),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              // remove the item using remove event
              BlocProvider.of<RandomListBloc>(context)
                  .add(ItemRemoveRequested(item: items[index]));
            },
          ),
        ),
        initialValue: items[index].text,
        textInputAction: index != (items.length - 1)
            ? TextInputAction.next
            : TextInputAction.done,
        // edit the item using add event to change text on go
        onChanged: (value) => BlocProvider.of<RandomListBloc>(context).add(
          ItemAddRequested(
            item: items[index].copyWith(
              text: value,
            ),
          ),
        ),
        onEditingComplete: () {
          if (index != (items.length - 1)) {
            // focus next 3 times because of
            // the current cross button and the next check box
            FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomListBloc, RandomListState>(
      builder: (context, state) {
        if (state.status == ItemsSubscriptionStatus.itemsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ItemsSubscriptionStatus.itemsLoaded ||
            state.status == ItemsSubscriptionStatus.randomPickLoading ||
            state.status == ItemsSubscriptionStatus.randomPickLoaded ||
            state.status == ItemsSubscriptionStatus.error) {
          final items = state.itemPool;
          return Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    FocusTraversalGroup(
                      child: SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _singleTextField(items, index),
                            childCount: items.length,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: TextButton(
                          onPressed: () {
                            BlocProvider.of<RandomListBloc>(context)
                                .add(ItemAddRequested(item: Item(text: '')));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Text('Add Item'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 60,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      BlocProvider.of<RandomListBloc>(context)
                          .add(const GetRandomItemEvent());
                    },
                    child: const Text('Pick Random Item'),
                  ),
                ),
              ),
            ],
          );
        }
        return const Placeholder();
      },
    );
  }
}
