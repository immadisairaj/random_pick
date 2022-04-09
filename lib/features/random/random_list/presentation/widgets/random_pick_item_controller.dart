import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late List<String> items;

  late ScrollController _scrollController;

  @override
  void initState() {
    items = <String>[''];
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _singleTextField(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: 'Input Item',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
            },
          ),
        ),
        textInputAction: index != (items.length - 1)
            ? TextInputAction.next
            : TextInputAction.done,
        onChanged: (value) => items[index] = value,
        onSubmitted: (_) => index != (items.length - 1)
            ? FocusScope.of(context).nextFocus()
            : FocusScope.of(context).unfocus(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                        return _singleTextField(index);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          items.add('');
                        });
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
                BlocProvider.of<RandomListBloc>(context).add(
                  GetRandomItemEvent(
                      itemPool: items.where((e) => e.isNotEmpty).toList()),
                );
              },
              child: const Text('Pick Random Item'),
            ),
          ),
        ),
      ],
    );
  }
}
