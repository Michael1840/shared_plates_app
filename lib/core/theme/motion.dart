import 'package:flutter/animation.dart';

abstract final class Motion {
  static const press = Duration(milliseconds: 120);
  static const small = Duration(milliseconds: 200);
  static const medium = Duration(milliseconds: 300);
  static const large = Duration(milliseconds: 450);
  static const stamp = Duration(milliseconds: 360);
  static const print = Duration(milliseconds: 520);
  static const paprika = Duration(milliseconds: 560);
  static const note = Duration(milliseconds: 640);
  static const stagger = Duration(milliseconds: 60);
  static const pulse = Duration(milliseconds: 1200);
  static const maxStaggered = 6;

  static const arrive = Cubic(0.22, 1, 0.36, 1);
  static const leave = Cubic(0.55, 0, 1, 0.45);
  static const bounce = Cubic(0.34, 1.56, 0.64, 1);

  static const pressScale = 0.97;
  static const riseOffset = 14.0;

  static Duration staggerDelay(int index, {Duration base = Duration.zero}) {
    final capped = index.clamp(0, maxStaggered - 1);
    return base + stagger * capped;
  }
}
