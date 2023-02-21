import 'package:flutter/material.dart';

/// Common widget for to display a message
///
/// [randomPicked] displays in bold with large size
/// [message] displays in normal size
/// when [isError] is true, [message] is displayed in red
class MessageDisplay extends StatelessWidget {
  /// creates a message display widget
  const MessageDisplay({
    required this.message,
    super.key,
    this.randomPicked,
    this.isError = false,
  });

  /// The picked number/item to display in bold and large size
  final String? randomPicked;

  /// The message to display in normal size
  final String message;

  /// set to true to display [message] in red
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (randomPicked != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                randomPicked!,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: isError ? Theme.of(context).colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
