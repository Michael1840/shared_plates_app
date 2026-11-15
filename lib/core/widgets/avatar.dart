import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    required this.name,
    super.key,
    this.seed,
    this.size = 44,
    this.fill,
    this.ink,
    this.ring,
  });

  final String name;
  final String? seed;
  final double size;
  final Color? fill;
  final Color? ink;
  final Color? ring;

  static (Color, Color) colorsFor(String seed) {
    final hash = seed.codeUnits.fold(0, (h, c) => (h * 31 + c) & 0x7fffffff);
    return Palette.avatars[hash % Palette.avatars.length];
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = colorsFor(seed ?? name);
    final letters = Formatters.initials(name);
    final config = size >= 72
        ? FontConfigs.h1
        : size >= 40
        ? FontConfigs.body2
        : FontConfigs.sublabel3;
    final border = ring;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: fill ?? bg,
          shape: BoxShape.circle,
          border: border == null ? null : Border.all(color: border, width: 2),
        ),
        alignment: Alignment.center,
        child: AppText(
          text: letters.isEmpty ? '?' : letters,
          config: config,
          weight: FontWeight.w700,
          color: ink ?? fg,
        ),
      ),
    );
  }
}
