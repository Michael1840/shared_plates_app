import 'dart:io';

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
    this.localPath,
    this.height,
    this.width = double.infinity,
    this.radius = Rounding.photo,
    this.semanticLabel,
  });

  final CoverStyle style;
  final String? imageUrl;
  final String? localPath;
  final double? height;
  final double width;
  final double radius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final local = localPath;
    final fallback = _IllustratedCover(style: style);
    final Widget image;
    if (local != null && local.isNotEmpty) {
      image = Image.file(
        File(local),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => url == null || url.isEmpty
            ? fallback
            : _NetworkCover(url: url, fallback: fallback),
      );
    } else if (url != null && url.isNotEmpty) {
      image = _NetworkCover(url: url, fallback: fallback);
    } else {
      image = fallback;
    }
    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(width: width, height: height, child: image),
      ),
    );
  }
}

class _NetworkCover extends StatelessWidget {
  const new({required this.url, required this.fallback});

  final String url;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => fallback,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Skeleton(height: double.infinity, radius: 0),
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
