// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions.dart';
import '../animations/ball_animation.dart';

class MyNetworkImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final double? svgHeight;
  final double? svgWidth;
  final double? radius;
  const MyNetworkImage({
    super.key,
    required this.url,
    this.radius,
    this.height,
    this.width,
    this.svgHeight,
    this.svgWidth,
  });

  @override
  Widget build(BuildContext context) {
    print('URL being passed to Image.network: $url');

    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(radius ?? 16),
      child: CachedNetworkImage(
        imageUrl: url,

        errorWidget: (context, error, stackTrace) {
          debugPrint('$error $stackTrace');

          return Container(
            decoration: BoxDecoration(
              color: context.textSecondary,
              borderRadius: BorderRadius.circular(radius ?? 16),
            ),
            height: height,
            width: width,

            child: Center(
              child: SvgPicture.asset(
                sharedPlatesSvg,
                width: svgHeight ?? 48,
                height: svgWidth ?? 48,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          );
        },

        progressIndicatorBuilder: (context, child, loadingProgress) =>
            Container(
              decoration: BoxDecoration(
                color: context.textSecondary,
                borderRadius: BorderRadius.circular(radius ?? 16),
              ),
              height: height,
              width: width,
              child: const Center(child: BallAnimation(ballSize: 10)),
            ),

        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}
