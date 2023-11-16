// referred from https://gist.github.com/fleepgeek/aacc7e956debb2b2a7b5b596575941f0

import 'package:flutter/material.dart';

/// This is a wrapper for [IndexedStack] for slide transition
///
/// Note: this is made/optimized only for two children
class AnimatedIndexedStack extends StatefulWidget {
  /// creates a slide transition on indexed stack
  const AnimatedIndexedStack({
    required this.index,
    required this.children,
    super.key,
  });

  /// current index to show
  final int index;

  /// clildren in the stack
  final List<Widget> children;

  @override
  State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _index;

  var _begin = Offset.zero;
  final _end = Offset.zero;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _index = widget.index;
    _controller.forward();
    _begin = const Offset(-1, 0);
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != _index) {
      _controller.reverse().then((_) {
        setState(() {
          _index = widget.index;
          _begin = _index == 0 ? const Offset(-1, 0) : const Offset(1, 0);
        });
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: Tween(begin: _begin, end: _end).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.ease,
            ),
          ),
          child: Transform.scale(
            scale: 1.015 - (_controller.value * 0.015),
            child: child,
          ),
        );
      },
      child: IndexedStack(
        index: _index,
        children: widget.children,
      ),
    );
  }
}
