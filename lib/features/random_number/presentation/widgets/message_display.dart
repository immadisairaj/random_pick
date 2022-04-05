import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String? randomPicked;
  final String message;
  final bool isError;

  const MessageDisplay({
    Key? key,
    this.randomPicked,
    required this.message,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (randomPicked != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  randomPicked!,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isError ? Colors.red : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
