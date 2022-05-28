import 'package:flutter/material.dart';
import 'package:random_pick/features/random/presentation/widgets/message_display.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

/// page to display when number picked history is clicked
class RandomHistoryNumberPage extends StatelessWidget {
  /// creates a random number picked page
  const RandomHistoryNumberPage({super.key, required this.randomNumberPicked});

  /// the random number picked
  final RandomNumberPicked randomNumberPicked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number picked'),
      ),
      body: Center(
        child: MessageDisplay(
          randomPicked: randomNumberPicked.randomNumber.toString(),
          message: 'is the random number picked from\n'
              '${randomNumberPicked.numberRange.min.toString()}'
              ' to '
              '${randomNumberPicked.numberRange.max.toString()}',
        ),
      ),
    );
  }
}
