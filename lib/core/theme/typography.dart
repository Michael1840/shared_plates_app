import 'package:flutter/material.dart';

enum FontRole { display, body, hand }

@immutable
class FontConfig {
  const new({
    required this.size,
    required this.lineHeight,
    this.letterSpacing,
    this.allCaps = false,
    this.role = FontRole.body,
    this.weight = FontWeight.w400,
  });

  final double size;
  final double lineHeight;
  final double? letterSpacing;
  final bool allCaps;
  final FontRole role;
  final FontWeight weight;
}

abstract final class FontConfigs {
  static const title = FontConfig(
    size: 40,
    lineHeight: 39 / 40,
    letterSpacing: -1.5,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const hero = FontConfig(
    size: 36,
    lineHeight: 37 / 36,
    letterSpacing: -1.3,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const h1 = FontConfig(
    size: 30,
    lineHeight: 32 / 30,
    letterSpacing: -1,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const h2 = FontConfig(
    size: 22,
    lineHeight: 26 / 22,
    letterSpacing: -0.4,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const h3 = FontConfig(
    size: 19,
    lineHeight: 20 / 19,
    letterSpacing: -0.3,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const h4 = FontConfig(
    size: 17,
    lineHeight: 20 / 17,
    letterSpacing: -0.2,
    role: FontRole.display,
    weight: FontWeight.w700,
  );
  static const h5 = FontConfig(
    size: 16,
    lineHeight: 20 / 16,
    role: FontRole.display,
    weight: FontWeight.w700,
  );
  static const brand = FontConfig(
    size: 20,
    lineHeight: 24 / 20,
    letterSpacing: -0.3,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const stampLarge = FontConfig(
    size: 26,
    lineHeight: 1,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const stamp = FontConfig(
    size: 16,
    lineHeight: 1,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const cookStep = FontConfig(
    size: 72,
    lineHeight: 64 / 72,
    role: FontRole.display,
    weight: FontWeight.w800,
  );
  static const cook = FontConfig(
    size: 26,
    lineHeight: 36 / 26,
    letterSpacing: -0.2,
    weight: FontWeight.w500,
  );
  static const body1 = FontConfig(size: 16, lineHeight: 24 / 16);
  static const body2 = FontConfig(size: 15, lineHeight: 21 / 15);
  static const body3 = FontConfig(size: 14, lineHeight: 20 / 14);
  static const button1 = FontConfig(
    size: 16,
    lineHeight: 20 / 16,
    weight: FontWeight.w700,
  );
  static const button2 = FontConfig(
    size: 14,
    lineHeight: 18 / 14,
    weight: FontWeight.w700,
  );
  static const sublabel1 = FontConfig(size: 13, lineHeight: 18 / 13);
  static const sublabel2 = FontConfig(size: 12, lineHeight: 17 / 12);
  static const sublabel3 = FontConfig(
    size: 11,
    lineHeight: 13 / 11,
    weight: FontWeight.w500,
  );
  static const stampUnit = FontConfig(
    size: 8,
    lineHeight: 1,
    letterSpacing: 1,
    allCaps: true,
    weight: FontWeight.w700,
  );
  static const stampUnitLarge = FontConfig(
    size: 11,
    lineHeight: 1,
    letterSpacing: 1,
    allCaps: true,
    weight: FontWeight.w700,
  );
  static const note = FontConfig(
    size: 20,
    lineHeight: 18 / 20,
    role: FontRole.hand,
    weight: FontWeight.w700,
  );
  static const noteLarge = FontConfig(
    size: 24,
    lineHeight: 22 / 24,
    role: FontRole.hand,
    weight: FontWeight.w700,
  );
}

@immutable
class SpTypography extends ThemeExtension<SpTypography> {
  const new({required this.display, required this.body, required this.hand});

  static const standard = SpTypography(
    display: 'BricolageGrotesque',
    body: 'Inter',
    hand: 'Caveat',
  );

  final String display;
  final String body;
  final String hand;

  String family(FontRole role) => switch (role) {
    FontRole.display => display,
    FontRole.body => body,
    FontRole.hand => hand,
  };

  TextStyle style(
    FontConfig config, {
    Color? color,
    FontWeight? weight,
    TextDecoration? decoration,
  }) => TextStyle(
    fontFamily: family(config.role),
    fontSize: config.size,
    height: config.lineHeight,
    letterSpacing: config.letterSpacing,
    fontWeight: weight ?? config.weight,
    color: color,
    decoration: decoration,
    leadingDistribution: TextLeadingDistribution.even,
  );

  @override
  SpTypography copyWith({String? display, String? body, String? hand}) =>
      SpTypography(
        display: display ?? this.display,
        body: body ?? this.body,
        hand: hand ?? this.hand,
      );

  @override
  SpTypography lerp(ThemeExtension<SpTypography>? other, double t) =>
      t < 0.5 || other is! SpTypography ? this : other;
}
