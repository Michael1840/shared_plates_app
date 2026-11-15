import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class FlashOnChange extends StatefulWidget {
  const FlashOnChange({required this.trigger, required this.child, super.key});

  final Object? trigger;
  final Widget child;

  @override
  State<FlashOnChange> createState() => _FlashOnChangeState();
}

class _FlashOnChangeState extends State<FlashOnChange>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
    value: 1,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Motion.arrive,
  );

  @override
  void didUpdateWidget(FlashOnChange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger && !context.reduceMotion) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final honey = context.sp.honey;
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => DecoratedBox(
        decoration: BoxDecoration(
          color: honey.withValues(alpha: 0.5 * (1 - _curve.value)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: child,
      ),
    );
  }
}
