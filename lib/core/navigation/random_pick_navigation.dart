import 'package:flutter/material.dart';

/// Navigation for two bottom tabs
class RandomPickNavigation {
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    // Random Number
    0: GlobalKey<NavigatorState>(),
    // Random List
    1: GlobalKey<NavigatorState>(),
  };
}
