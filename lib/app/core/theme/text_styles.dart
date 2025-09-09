part of 'theme.dart';

enum _TextType { heading, primary, secondary }

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final TextOverflow? overflow;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final int? maxLines;
  final FontStyle? style;
  final FontWeight weight;

  final _TextType _type;

  const AppText.heading({
    super.key,
    required this.text,
    this.size = 22,
    this.alignment,
    this.maxLines,
    this.decoration,
    this.overflow,
    this.color,
    this.style,
    this.weight = Weights.bold,
  }) : _type = _TextType.heading;

  const AppText.primary({
    super.key,
    required this.text,
    this.size = 14,
    this.alignment,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.color,
    this.style,
    this.weight = Weights.reg,
  }) : _type = _TextType.primary;

  const AppText.secondary({
    super.key,
    required this.text,
    this.size = 14,
    this.alignment,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.color,
    this.style,
    this.weight = Weights.reg,
  }) : _type = _TextType.secondary;

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        color ??
        switch (_type) {
          _TextType.heading => context.textPrimary,
          _TextType.primary => context.textPrimary,
          _TextType.secondary => context.textSecondary,
        };

    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: alignment,
      style: context.myTextStyle(
        color: resolvedColor,
        size: size,
        style: style,
        weight: weight,
        decoration: decoration,
      ),
    );
  }
}
