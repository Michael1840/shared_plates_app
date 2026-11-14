import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class DotGridBackground extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.background,
      child: CustomPaint(
        painter: _DotGridPainter(context.sp.dotGrid),
        child: child,
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  new(this.color);

  static const double _step = 20;
  static const double _radius = 1.1;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final columns = (size.width / _step).ceil() + 1;
    final rows = (size.height / _step).ceil() + 1;
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < columns; col++) {
        canvas.drawCircle(
          Offset(col * _step + _step / 2, row * _step + _step / 2),
          _radius,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => oldDelegate.color != color;
}
