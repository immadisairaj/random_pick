import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/random_number_bloc.dart';

class RandomController extends StatefulWidget {
  const RandomController({
    Key? key,
  }) : super(key: key);

  @override
  State<RandomController> createState() => _RandomControllerState();
}

class _RandomControllerState extends State<RandomController> {
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
    return Expanded(
      flex: 1,
      child: Column(
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
                    onSubmitted: (_) => dispatchRandomNumber(),
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
                  child: Center(child: Text('Max (exclusive)')),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: dispatchRandomNumber,
              child: const Text('Pick Random Number'),
            ),
          ),
        ],
      ),
    );
  }

  void dispatchRandomNumber() {
    BlocProvider.of<RandomNumberBloc>(context).add(GetRandomNumberForRange(
        min: _minController.text, max: _maxController.text));
  }
}
