import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/random_number_bloc.dart';

/// Widget that controlls the [RandomNumberBloc]
///
/// - contains the min and max text fields
/// - emits [GetRandomNumberForRange] event to get a random number
class RandomNumberController extends StatefulWidget {
  /// creates a random number controller
  const RandomNumberController({
    super.key,
  });

  @override
  State<RandomNumberController> createState() => _RandomNumberControllerState();
}

class _RandomNumberControllerState extends State<RandomNumberController> {
  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    const inputMin = '1';
    const inputMax = '';

    super.initState();

    _minController = TextEditingController(text: inputMin);
    _maxController = TextEditingController(text: inputMax);
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RandomNumberBloc, RandomNumberState>(
      listenWhen: (previous, current) => current is RandomNumberLoaded,
      listener: (context, state) {
        // clear out the min and max text fields
        _minController.text = '1';
        _maxController.clear();
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _minController,
                      textAlign: TextAlign.center,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Min value',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _maxController,
                      textAlign: TextAlign.center,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _dispatchRandomNumber(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Max value',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(child: Text('Min (inclusive)')),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(child: Text('Max (inclusive)')),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: _dispatchRandomNumber,
                child: const Text('Pick Random Number'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _dispatchRandomNumber() {
    FocusScope.of(context).unfocus();
    BlocProvider.of<RandomNumberBloc>(context).add(GetRandomNumberForRange(
        min: _minController.text, max: _maxController.text));
  }
}
