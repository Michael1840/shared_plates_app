import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';

class RecipeCover extends StatelessWidget {
  const new({
    required this.style,
    super.key,
    this.imageUrl,
    this.height,
    this.width = double.infinity,
    this.radius = Rounding.photo,
    this.semanticLabel,
  });

  final CoverStyle style;
  final String? imageUrl;
  final double? height;
  final double width;
  final double radius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final fallback = _IllustratedCover(style: style);
    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          width: width,
          height: height,
          child: url == null || url.isEmpty
              ? fallback
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => fallback,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Skeleton(height: double.infinity, radius: 0),
                ),
        ),
      ),
    );
  }
}

class _IllustratedCover extends StatelessWidget {
  const new({required this.style});

  final CoverStyle style;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(style.asset, fit: BoxFit.cover);
  }
}
