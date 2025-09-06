import 'package:flutter/material.dart';

class BallAnimation extends StatefulWidget {
  final double ballSize;
  final List<Color>? colors;

  const BallAnimation({
    super.key,
    required this.ballSize,
    this.colors,
  });

  @override
  State<BallAnimation> createState() => BallAnimationState();
}

class BallAnimationState extends State<BallAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<int> _balls = [1, 2, 3, 4];
  final List<Color> _colors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  int _hiddenBallIndex = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _hiddenBallIndex = (_hiddenBallIndex + 1) % 4;
          });
          _controller.forward(from: 0.0);
        }
      });
    _controller.forward();
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _balls.asMap().entries.map((entry) {
            int idx = entry.key;

            double scale = 1.0;
            if (idx == _hiddenBallIndex) {
              scale = 0.0;
            } else if ((idx + 1) % 4 == _hiddenBallIndex) {
              scale = _controller.value;
            } else if ((idx + 3) % 4 == _hiddenBallIndex) {
              scale = 1.0 - _controller.value;
            }

            return Transform.scale(
              scale: scale,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                width: widget.ballSize,
                height: widget.ballSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.colors?[idx] ?? _colors[idx],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
