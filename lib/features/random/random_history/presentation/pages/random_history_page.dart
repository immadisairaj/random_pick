import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_pick/features/random/presentation/widgets/message_display.dart';
import 'package:random_pick/features/random/random_history/presentation/bloc/random_history_bloc.dart';
import 'package:random_pick/features/random/random_history/presentation/pages/random_history_list_view.dart';
import 'package:random_pick/injection_container.dart';

/// Page that displays the history of pick
class RandomHistoryPage extends StatelessWidget {
  /// creates a random history page
  const RandomHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random History'),
      ),
      body: BlocProvider(
        create: (_) => getIt<RandomHistoryBloc>()
          ..add(const HistorySubscriptionRequested()),
        child: Center(
          child: BlocBuilder<RandomHistoryBloc, RandomHistoryState>(
            builder: (context, state) {
              if (state.status == RandomHistoryStatus.initial) {
                return const MessageDisplay(
                  message: 'Starting to load',
                );
              } else if (state.status == RandomHistoryStatus.loading) {
                return const CircularProgressIndicator();
              } else if (state.status == RandomHistoryStatus.error) {
                return MessageDisplay(
                  isError: true,
                  message: state.errorMessage!,
                );
              } else if (state.status == RandomHistoryStatus.loaded) {
                return RandomHistoryListView(
                  history: state.historyList,
                );
              }
              return const Placeholder();
            },
          ),
        ),
      ),
    );
  }
}
