import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../bloc/random_list_bloc.dart';

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
    Key? key,
  }) : super(key: key);

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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 0,
            child: Checkbox(
              value: items[index].selected,
              // edit the item using add event to select/deselect
              onChanged: (value) =>
                  BlocProvider.of<RandomListBloc>(context).add(ItemAddRequested(
                      item: items[index].copyWith(
                selected: value,
              ))),
            ),
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Input Item',
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
              onChanged: (value) =>
                  BlocProvider.of<RandomListBloc>(context).add(ItemAddRequested(
                      item: items[index].copyWith(
                text: value,
              ))),
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
          ),
        ],
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
          var items = state.itemPool;
          return Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FocusTraversalGroup(
                          // TODO: use Slivers instead of listview
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              if (items.isEmpty) return Container();
                              return _singleTextField(items, index);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              BlocProvider.of<RandomListBloc>(context)
                                  .add(ItemAddRequested(item: Item(text: '')));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add),
                                Text('Add Item'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
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
