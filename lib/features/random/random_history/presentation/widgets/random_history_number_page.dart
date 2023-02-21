import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_pick/features/random/presentation/widgets/message_display.dart';
import 'package:random_pick/features/random/random_number/domain/entities/random_number_picked.dart';

/// page to display when number picked history is clicked
class RandomHistoryNumberPage extends StatelessWidget {
  /// creates a random number picked page
  ///
  /// [isHistory] defaults to false; pass true to be able to delete from history
  const RandomHistoryNumberPage({
    required this.randomNumberPicked,
    super.key,
    this.isHistory = false,
  });

  /// the random number picked
  final RandomNumberPicked randomNumberPicked;

  /// if the history is false, it's navigated from random list;
  /// else it's navigated from pick history
  final bool isHistory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number picked'),
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
      body: Center(
        child: MessageDisplay(
          randomPicked: randomNumberPicked.randomNumber.toString(),
          message: 'is the random number picked from\n'
              '${randomNumberPicked.numberRange.min}'
              ' to '
              '${randomNumberPicked.numberRange.max}',
        ),
      ),
    );
  }
}
