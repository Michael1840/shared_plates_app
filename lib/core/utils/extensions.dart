import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/sp_colors.dart';
import 'package:shared_plates_app/core/theme/typography.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  SpColors get sp => theme.extension<SpColors>() ?? SpColors.light;
  SpTypography get typography =>
      theme.extension<SpTypography>() ?? SpTypography.standard;
  bool get isDark => theme.brightness == Brightness.dark;

  Color get background => sp.background;
  Color get container => sp.card;
  Color get raised => sp.raised;
  Color get textPrimary => sp.textPrimary;
  Color get textSecondary => sp.textSecondary;
  Color get textMuted => sp.textMuted;
  Color get line => sp.line;
  Color get primary => sp.primary;
  Color get onPrimary => sp.onPrimary;
  Color get primaryDeep => sp.primaryDeep;
  Color get herb => sp.herb;
  Color get honey => sp.honey;

  TextStyle textStyle(
    FontConfig config, {
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
  }) => typography.style(
    config,
    color: color,
    weight: weight,
    decoration: decoration,
  );

  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  Duration motion(Duration duration) => reduceMotion ? Duration.zero : duration;
}

extension WidgetLayout on Widget {
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.fromLTRB(left, top, right, bottom),
    child: this,
  );

  Widget expand({int flex = 1}) => Expanded(flex: flex, child: this);

  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);

  Widget visible({
    required bool when,
    Widget fallback = const SizedBox.shrink(),
  }) => when ? this : fallback;

  Widget toSliver() => SliverToBoxAdapter(child: this);

  Widget rotated(double degrees) => degrees == 0
      ? this
      : Transform.rotate(angle: degrees * 0.017453292519943295, child: this);
}

extension CleanError on Exception {
  String get cleanError =>
      toString().replaceFirst(RegExp(r'^\w*Exception:\s*'), '');
}

extension Degrees on num {
  double get radians => this * 0.017453292519943295;
}
