import 'package:flutter/material.dart';

import '../utils/extensions.dart';

part 'colors.dart';
part 'text_styles.dart';

class MyTheme {
  static final ThemeData _baseTheme = ThemeData(
    useMaterial3: true,
    navigationRailTheme: const NavigationRailThemeData(groupAlignment: 0),
  );

  static final ColorScheme lightColorScheme = const ColorScheme.light()
      .copyWith(
        surface: AppColors.backgroundLight,
        onSurface: TextColors.primaryLight,
        onSurfaceVariant: TextColors.secondary,
        onInverseSurface: TextColors.primaryDark,
        primaryContainer: AppColors.containerLight,
        onPrimaryContainer: AppColors.onContainer,
        onTertiaryContainer: AppColors.containerLight,
        outline: BorderColors.primary,
        outlineVariant: BorderColors.secondary,

        primary: AccentColors.primary,
        secondaryContainer: LoadingColors.lightContainer,
        onSecondaryContainer: LoadingColors.lightOnContainer,
      );

  static final ColorScheme darkColorScheme = const ColorScheme.dark().copyWith(
    surface: AppColors.backgroundDark,
    onSurface: TextColors.primaryDark,
    onSurfaceVariant: TextColors.secondary,
    onInverseSurface: TextColors.primaryLight,
    primaryContainer: AppColors.containerDark,
    onPrimaryContainer: AppColors.onContainer,
    onTertiaryContainer: AppColors.containerLight,
    outline: BorderColors.primary,
    outlineVariant: BorderColors.secondary,

    primary: AccentColors.primary,
    secondaryContainer: LoadingColors.darkContainer,
    onSecondaryContainer: LoadingColors.darkOnContainer,
  );

  static ThemeData get lightTheme => _baseTheme.copyWith(
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    appBarTheme: const AppBarTheme().copyWith(
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
    ),
  );

  static ThemeData get darkTheme => _baseTheme.copyWith(
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    appBarTheme: const AppBarTheme().copyWith(
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
  );
}
