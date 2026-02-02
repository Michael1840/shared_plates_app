import 'package:flutter/material.dart';

class BallAnimation extends StatefulWidget {
  final double ballSize;

  const BallAnimation({super.key, required this.ballSize});

  @override
  BallAnimationState createState() => BallAnimationState();
}

class BallAnimationState extends State<BallAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<Color> _colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _colors.length,
      (index) => AnimationController(
        duration: const Duration(
          milliseconds: 1000,
        ), // Duration for one full cycle
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
        ),
      );
    }).toList();

    _startAnimation();
  }

  void _startAnimation() async {
    // Return immediately if the widget is not mounted.
    if (!mounted) {
      return;
    }

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].forward();
      await Future.delayed(const Duration(milliseconds: 200));

      // Check again after the delay before proceeding.
      if (!mounted) {
        return;
      }
    }

    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      // Check again after the delay before proceeding.
      if (!mounted) {
        return;
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));

    // Recursively call only if the widget is still mounted.
    if (mounted) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _colors.asMap().entries.map((entry) {
        final idx = entry.key;
        return FadeTransition(
          opacity: _animations[idx],
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8),
            width: widget.ballSize,
            height: widget.ballSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.value,
            ),
          ),
        );
      }).toList(),
    );
  }
}
