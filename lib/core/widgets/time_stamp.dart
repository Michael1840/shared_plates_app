import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';

class TimeStamp extends StatelessWidget {
  const TimeStamp({
    required this.minutes,
    super.key,
    this.large = false,
    this.animate = true,
    this.delay = const Duration(milliseconds: 640),
    this.borderColor,
  });

  final int minutes;
  final bool large;
  final bool animate;
  final Duration delay;
  final Color? borderColor;

  String get _value =>
      minutes >= 100 ? '${(minutes / 60).round()}' : '$minutes';

  String get _unit => minutes >= 100 ? 'HR' : 'MIN';

  @override
  Widget build(BuildContext context) {
    final size = large ? 80.0 : 54.0;
    final stamp = Semantics(
      label: '$minutes minutes',
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? context.container,
            width: large ? 4 : 3,
          ),
          boxShadow: [
            BoxShadow(
              color: context.primary.withValues(alpha: 0.3),
              blurRadius: large ? 14 : 10,
              offset: Offset(0, large ? 6 : 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: _value,
              config: large ? FontConfigs.stampLarge : FontConfigs.stamp,
              color: context.onPrimary,
            ),
            AppText(
              text: _unit,
              config: large
                  ? FontConfigs.stampUnitLarge
                  : FontConfigs.stampUnit,
              color: context.onPrimary,
            ),
          ],
        ),
      ).rotated(10),
    );
    if (!animate) return stamp;
    return Entrance(style: EntranceStyle.stamp, delay: delay, child: stamp);
  }
}
