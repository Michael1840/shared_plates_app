import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';

extension SheetContext on BuildContext {
  Future<T?> bottomSheet<T>(Widget child) => showModalBottomSheet<T>(
    context: this,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: background,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Rounding.sheet)),
    ),
    sheetAnimationStyle: AnimationStyle(
      duration: motion(Motion.large),
      reverseDuration: motion(Motion.medium),
      curve: Motion.arrive,
      reverseCurve: Motion.leave,
    ),
    builder: (_) => DotGridBackground(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Spacing.gutter,
          0,
          Spacing.gutter,
          MediaQuery.paddingOf(this).bottom + Spacing.l,
        ),
        child: child,
      ),
    ),
  );
}
