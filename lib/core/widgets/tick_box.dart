import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class TickBox extends StatefulWidget {
  const new({required this.checked, super.key, this.size = 24});

  final bool checked;
  final double size;

  @override
  State<TickBox> createState() => _TickBoxState();
}

class _TickBoxState extends State<TickBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    value: widget.checked ? 1 : 0,
  );

  @override
  void didUpdateWidget(TickBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checked == widget.checked) return;
    if (context.reduceMotion) {
      _controller.value = widget.checked ? 1 : 0;
    } else if (widget.checked) {
      _controller.forward(from: 0);
    } else {
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    return AnimatedContainer(
      duration: context.motion(Motion.small),
      curve: Motion.arrive,
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.checked ? sp.success : sp.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.checked ? sp.success : sp.handle,
          width: 2,
        ),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _TickPainter(
            progress: Motion.arrive.transform(_controller.value),
            color: sp.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  new({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final s = size.width / 24;
    final path = Path()
      ..moveTo(5 * s, 12.5 * s)
      ..lineTo(9.5 * s, 17 * s)
      ..lineTo(19 * s, 7.5 * s);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_TickPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
