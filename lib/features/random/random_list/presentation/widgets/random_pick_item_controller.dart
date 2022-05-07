import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../bloc/random_list_bloc.dart';

/// Controller widget for random list
///
/// - contains dynamic list of items (text fields)
/// - dispatches the random item pick event
class RandomPickItemController extends StatefulWidget {
  /// creates a contrommer for random list
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
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _singleTextField(List<Item> items, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Input Item',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              BlocProvider.of<RandomListBloc>(context)
                  .add(ItemRemoveRequested(item: items[index]));
            },
          ),
        ),
        textInputAction: index != (items.length - 1)
            ? TextInputAction.next
            : TextInputAction.done,
        onChanged: (value) =>
            BlocProvider.of<RandomListBloc>(context).add(ItemAddRequested(
                item: items[index].copyWith(
          text: value,
        ))),
        onSubmitted: (_) => index != (items.length - 1)
            ? FocusScope.of(context).nextFocus()
            : FocusScope.of(context).unfocus(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RandomListBloc, RandomListState>(
      builder: (context, state) {
        if (state.status == ItemsSubscriptionStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ItemsSubscriptionStatus.loaded ||
            state is RandomListError ||
            state is RandomListPickLoaded ||
            state is RandomListPickLoading) {
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
