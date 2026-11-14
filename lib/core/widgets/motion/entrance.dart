import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

enum EntranceStyle { rise, print, pop, stamp, write }

class Entrance extends StatefulWidget {
  const new({
    required this.child,
    super.key,
    this.style = EntranceStyle.rise,
    this.delay = Duration.zero,
  });

  factory staggered({
    required int index,
    required Widget child,
    Key? key,
    EntranceStyle style = EntranceStyle.rise,
    Duration base = Duration.zero,
  }) => Entrance(
    key: key,
    style: style,
    delay: Motion.staggerDelay(index, base: base),
    child: child,
  );

  final Widget child;
  final EntranceStyle style;
  final Duration delay;

  @override
  State<Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<Entrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
  );
  late final CurvedAnimation _curved = CurvedAnimation(
    parent: _controller,
    curve: _curve,
  );
  Timer? _timer;
  bool _started = false;

  Duration get _duration => switch (widget.style) {
    EntranceStyle.rise => Motion.large,
    EntranceStyle.print => Motion.print,
    EntranceStyle.pop => Motion.paprika,
    EntranceStyle.stamp => Motion.stamp,
    EntranceStyle.write => Motion.note,
  };

  Curve get _curve => switch (widget.style) {
    EntranceStyle.pop || EntranceStyle.stamp => Motion.bounce,
    _ => Motion.arrive,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (context.reduceMotion) {
      _controller.value = 1;
      return;
    }
    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }
    _timer = Timer(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curved,
      child: widget.child,
      builder: (context, child) =>
          _EntranceFrame(style: widget.style, t: _curved.value, child: child!),
    );
  }
}

class _EntranceFrame extends StatelessWidget {
  const new({required this.style, required this.t, required this.child});

  final EntranceStyle style;
  final double t;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final opacity = t.clamp(0.0, 1.0);
    final remaining = 1 - t;
    return switch (style) {
      EntranceStyle.rise => Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, Motion.riseOffset * remaining),
          child: child,
        ),
      ),
      EntranceStyle.print => Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, 22 * remaining),
          child: Transform.rotate(
            angle: (-5 * remaining).radians,
            child: child,
          ),
        ),
      ),
      EntranceStyle.pop => Opacity(
        opacity: opacity,
        child: Transform.translate(
          offset: Offset(0, Motion.riseOffset * remaining),
          child: Transform.scale(scale: 0.6 + 0.4 * t, child: child),
        ),
      ),
      EntranceStyle.stamp => Opacity(
        opacity: opacity,
        child: Transform.scale(scale: 1.7 - 0.7 * t, child: child),
      ),
      EntranceStyle.write => ClipRect(
        child: Align(
          alignment: Alignment.centerLeft,
          widthFactor: opacity,
          child: child,
        ),
      ),
    };
  }
}
