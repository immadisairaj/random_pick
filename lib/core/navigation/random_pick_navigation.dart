import 'package:flutter/material.dart';
import 'package:random_pick/features/random/random_list/presentation/pages/random_list_page.dart';

/// Navigation for two bottom tabs
class RandomPickNavigation {
  /// navigates to the [RandomListPage]
  ///
  /// - 0 for random number page
  /// - 1 for random list page
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    // Random Number
    0: GlobalKey<NavigatorState>(),
    // Random List
    1: GlobalKey<NavigatorState>(),
  };
}
