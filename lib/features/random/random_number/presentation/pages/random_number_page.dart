import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';

import '../bloc/random_number_bloc.dart';
import '../widgets/widgets.dart';

class RandomNumberPage extends StatelessWidget {
  const RandomNumberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Number')),
      body: BlocProvider(
        create: (_) => getIt<RandomNumberBloc>(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<RandomNumberBloc, RandomNumberState>(
                builder: (context, state) {
                  if (state is RandomNumberEmpty) {
                    return const MessageDisplay(
                      message: 'Input min and max values',
                    );
                  } else if (state is RandomNumberLoading) {
                    return const Expanded(
                      flex: 1,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is RandomNumberLoaded) {
                    return MessageDisplay(
                      randomPicked:
                          state.randomNumberPicked.randomNumber.toString(),
                      message: 'is the random number picked from\n'
                          '${state.randomNumberPicked.numberRange.min.toString()}'
                          ' to '
                          '${state.randomNumberPicked.numberRange.max.toString()}',
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
              const RandomController(),
            ],
          ),
        ),
      ),
    );
  }
}
