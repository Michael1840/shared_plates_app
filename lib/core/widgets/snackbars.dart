import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

extension SnackContext on BuildContext {
  void showSnackBarError(String message) =>
      _show(message, icon: SpIcons.ban, tint: primary);

  void showSnackBarMessage(String message) =>
      _show(message, icon: SpIcons.check, tint: herb);

  void _show(String message, {required SpIcons icon, required Color tint}) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          duration: const Duration(seconds: 3),
          content: Container(
            padding: const EdgeInsets.all(Spacing.m),
            decoration: BoxDecoration(
              color: container,
              borderRadius: BorderRadius.circular(Rounding.row),
              boxShadow: [
                BoxShadow(
                  color: sp.shadow,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              spacing: Spacing.s,
              children: [
                SpIcon(icon, color: tint),
                AppText(text: message, config: FontConfigs.body3).expand(),
              ],
            ),
          ),
        ),
      );
  }
}
