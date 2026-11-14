import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_plates_app/core/theme/page_transitions.dart';
import 'package:shared_plates_app/core/theme/sp_colors.dart';
import 'package:shared_plates_app/core/theme/typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(SpColors.light, Brightness.light);

  static ThemeData get dark => _build(SpColors.dark, Brightness.dark);

  static ThemeData _build(SpColors c, Brightness brightness) {
    const type = SpTypography.standard;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.herb,
      onSecondary: c.onPrimary,
      tertiary: c.honey,
      onTertiary: c.honeyInk,
      error: c.primaryDeep,
      onError: c.onPrimary,
      surface: c.background,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      primaryContainer: c.card,
      onPrimaryContainer: c.textPrimary,
      surfaceContainerHighest: c.raised,
      outline: c.line,
      outlineVariant: c.line,
      shadow: c.shadow,
    );
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      fontFamily: type.body,
      splashFactory: NoSplash.splashFactory,
      pageTransitionsTheme: ReduceMotionTransitions.theme,
      highlightColor: Colors.transparent,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.primary,
        selectionColor: c.primary.withValues(alpha: 0.25),
        selectionHandleColor: c.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: c.textPrimary,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.background,
        modalBarrierColor: c.textPrimary.withValues(alpha: 0.5),
        dragHandleColor: c.handle,
      ),
      extensions: [c, type],
    );
  }
}
