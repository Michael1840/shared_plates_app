import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/tape.dart';

class PhotoPrint extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.tilt = -1.5,
    this.tapeTilt,
    this.padding = const EdgeInsets.fromLTRB(8, 8, 8, 12),
    this.radius = Rounding.print,
    this.width,
    this.animate = true,
    this.delay = const Duration(milliseconds: 160),
  });

  final Widget child;
  final double tilt;
  final double? tapeTilt;
  final EdgeInsets padding;
  final double radius;
  final double? width;
  final bool animate;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final tape = tapeTilt;
    final print = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: context.sp.printShadow,
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
        if (tape != null)
          Positioned(
            top: -11,
            left: 0,
            right: 0,
            child: Center(child: Tape(tilt: tape)),
          ),
      ],
    ).rotated(tilt);
    if (!animate) return print;
    return Entrance(style: EntranceStyle.print, delay: delay, child: print);
  }
}
