import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    required this.onTap,
    super.key,
    this.semanticLabel,
    this.isButton = true,
    this.minSize = Sizes.minTap,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool isButton;
  final double minSize;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set({required bool down}) {
    if (widget.onTap == null || _down == down) return;
    setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: widget.isButton,
      enabled: widget.onTap != null,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _set(down: true),
        onTapUp: (_) => _set(down: false),
        onTapCancel: () => _set(down: false),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.minSize,
            minHeight: widget.minSize,
          ),
          child: AnimatedScale(
            scale: _down ? Motion.pressScale : 1,
            duration: context.motion(Motion.press),
            curve: Motion.arrive,
            child: Center(widthFactor: 1, heightFactor: 1, child: widget.child),
          ),
        ),
      ),
    );
  }
}
