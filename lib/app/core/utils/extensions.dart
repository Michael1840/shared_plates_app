import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme.dart';

extension AnimationExtensions on Widget {
  Widget toSliver() => SliverToBoxAdapter(child: this);

  Widget listAnimate(int index) => animate()
      .fade(duration: 200.ms)
      .slide(begin: const Offset(-0.1, 0), duration: 200.ms)
      .then(delay: (150 * (index % 10)).ms);
}

extension WidgetExtension on Widget? {
  /// return padding top
  Padding paddingTop(double top) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: this,
    );
  }

  /// return padding left
  Padding paddingLeft(double left) {
    return Padding(
      padding: EdgeInsets.only(left: left),
      child: this,
    );
  }

  /// return padding right
  Padding paddingRight(double right) {
    return Padding(
      padding: EdgeInsets.only(right: right),
      child: this,
    );
  }

  /// return padding bottom
  Padding paddingBottom(double bottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: this,
    );
  }

  /// return padding all
  Padding paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// return custom padding from each side
  Padding paddingOnly({
    double top = 0.0,
    double left = 0.0,
    double bottom = 0.0,
    double right = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }

  /// return padding symmetric
  Padding paddingSymmetric({double vertical = 0.0, double horizontal = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }

  /// set visibility
  Widget visible(bool visible, {Widget? defaultWidget}) {
    return visible ? this! : (defaultWidget ?? const SizedBox());
  }

  /// add Expanded to parent widget
  Widget expand({flex = 1}) => Expanded(flex: flex, child: this!);

  /// add Flexible to parent widget
  Widget flexible({flex = 1, FlexFit? fit}) {
    return Flexible(flex: flex, fit: fit ?? FlexFit.loose, child: this!);
  }

  /// add tap to parent widget
  Widget onTap(
    Function? function, {
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? hoverColor,
    Color? highlightColor,
  }) {
    return InkWell(
      onTap: function as void Function()?,
      borderRadius: borderRadius,
      splashFactory: NoSplash.splashFactory,
      splashColor: splashColor ?? Colors.transparent,
      hoverColor: hoverColor ?? Colors.transparent,
      highlightColor: highlightColor ?? Colors.transparent,
      child: this,
    );
  }
}

extension StringExtentions on String? {
  bool get isNull => this == null;
}

extension TextEditingControllerExtensions on TextEditingController {
  String get trimmedText => text.trim();

  double? get asDouble => double.tryParse(trimmedText);
}

extension BuildContextExtension on BuildContext {
  void showSnackBarError(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: StatusColors.redDark,
            border: Border.all(color: StatusColors.redLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText.primary(
                text: 'Oops!',
                size: 12,
                weight: Weights.bold,
              ),
              AppText.secondary(text: message, size: 10),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: StatusColors.greenDark,
            border: Border.all(color: StatusColors.greenLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText.primary(
                text: 'Success!',
                size: 12,
                weight: Weights.bold,
              ),
              AppText.secondary(text: message, size: 10),
            ],
          ),
        ),
      ),
    );
  }
}

extension ThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  Color get background => colorScheme.surface;
  Color get container => colorScheme.primaryContainer;
  Color get onContainer => colorScheme.onPrimaryContainer;
  Color get containerInverse => colorScheme.onTertiaryContainer;

  Color get textPrimary => colorScheme.onSurface;
  Color get textSecondary => colorScheme.onSurfaceVariant;
  Color get textInverse => colorScheme.onInverseSurface;

  Color get borderPrimary => colorScheme.outline;
  Color get borderSecondary => colorScheme.outlineVariant;

  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;

  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;

  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;

  Color get darkText => TextColors.primaryLight;
  Color get white => Colors.white;
  Color get green => AccentColors.green;

  TextStyle myTextStyle({
    Color? color,
    FontWeight? weight,
    double? size,
    FontStyle? style,
    TextDecoration? decoration,
  }) => GoogleFonts.poppins(
    color: color,
    fontWeight: weight,
    fontStyle: style,
    fontSize: size,
    decoration: decoration,
    height: 1.2,
  );
}
