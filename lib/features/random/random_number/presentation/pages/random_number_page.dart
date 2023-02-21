import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_pick/features/random/presentation/widgets/message_display.dart';
import 'package:random_pick/features/random/random_number/presentation/bloc/random_number_bloc.dart';
import 'package:random_pick/features/random/random_number/presentation/widgets/random_number_controller.dart';
import 'package:random_pick/injection_container.dart';

/// Widget or Page that displays the random number pick
class RandomNumberPage extends StatelessWidget {
  /// creates a random number page
  const RandomNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<RandomNumberBloc>(),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: BlocBuilder<RandomNumberBloc, RandomNumberState>(
                builder: (context, state) {
                  if (state is RandomNumberEmpty) {
                    return const MessageDisplay(
                      message: 'Input min and max values',
                    );
                  } else if (state is RandomNumberLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is RandomNumberLoaded) {
                    final picked = state.randomNumberPicked;
                    return MessageDisplay(
                      randomPicked: picked.randomNumber.toString(),
                      message: 'is the random number picked from\n'
                          '${picked.numberRange.min}'
                          ' to '
                          '${picked.numberRange.max}',
                    );
                  } else if (state is RandomNumberError) {
                    return MessageDisplay(
                      isError: true,
                      message: state.errorMessage,
                    );
                  }
                  return const Placeholder();
                },
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: RandomNumberController(),
            ),
          ],
        ),
      ),
    );
  }
}
