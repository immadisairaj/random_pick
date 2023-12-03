import 'package:flutter/material.dart';
import 'package:random_pick/core/utils/constants.dart';

const _animationDuration = Duration(milliseconds: 500);

/// a customized bottom bar use it similar to [NavigationBar]
class CustomBottomBar extends StatelessWidget {
  /// creates a customized bottom bar for this application
  const CustomBottomBar({
    required this.destinations,
    required this.onDestinationSelected,
    this.selectedIndex = 0,
    super.key,
  }) : assert(destinations.length >= 2, 'Destinations should be at least 2');

  /// the index that is selected
  final int selectedIndex;

  /// list of destinations
  final List<CustomBottomBarDestination> destinations;

  /// call back when a destination is selected
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: _animationDuration,
        margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(Constants.circularRadius),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: destinations.asMap().entries.map(
            (item) {
              final index = item.key;
              final destination = item.value;
              final highlight = index == selectedIndex;

              final defaultIconSize = Theme.of(context).iconTheme.size ?? 24;

              return GestureDetector(
                onTap: () => onDestinationSelected?.call(index),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      AnimatedSize(
                        duration: _animationDuration,
                        child: Icon(
                          destination.icon,
                          size: highlight
                              ? (defaultIconSize + 5)
                              : defaultIconSize,
                          color: highlight
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                          semanticLabel: destination.label,
                        ),
                      ),
                      if (highlight)
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            destination.label,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

/// similar to navigation but just a class used in [CustomBottomBar]
class CustomBottomBarDestination {
  /// create a destination for the [CustomBottomBar] by
  /// passing [icon] and [label]
  const CustomBottomBarDestination({
    required this.selectedIcon,
    required this.icon,
    required this.label,
  });

  /// icon to be shown when current destination is selected
  final IconData selectedIcon;

  /// icon to be shown on bottom bar
  final IconData icon;

  /// curresponding label to be shown on bottom bar
  final String label;
}
