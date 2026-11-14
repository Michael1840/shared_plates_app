import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class AppText extends StatelessWidget {
  const new({
    required this.text,
    required this.config,
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
  }) : _secondary = false;

  const new secondary({
    required this.text,
    required this.config,
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
  }) : _secondary = true;

  final String text;
  final FontConfig config;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool _secondary;

  @override
  Widget build(BuildContext context) {
    final fallback = _secondary ? context.textSecondary : context.textPrimary;
    return Text(
      config.allCaps ? text.toUpperCase() : text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      style: context.textStyle(
        config,
        color: color ?? fallback,
        weight: weight,
      ),
    );
  }
}

class AppRichText extends StatelessWidget {
  const new({
    required this.spans,
    required this.config,
    super.key,
    this.color,
    this.align,
  });

  final List<TextSpan> spans;
  final FontConfig config;
  final Color? color;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: spans),
      textAlign: align,
      style: context.textStyle(config, color: color ?? context.textPrimary),
    );
  }
}
