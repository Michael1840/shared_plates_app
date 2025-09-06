import 'dart:math' as math;

import 'package:flutter/material.dart';

class ShakeContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShakeContainer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  ShakeContainerState createState() => ShakeContainerState();
}

class ShakeContainerState extends State<ShakeContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    final CurvedAnimation curve =
        CurvedAnimation(parent: _controller, curve: Curves.elasticIn);
    _animation = Tween<double>(begin: 0, end: 10).animate(curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              _animation.value * (math.sin(_controller.value * 2 * math.pi)),
              0),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
