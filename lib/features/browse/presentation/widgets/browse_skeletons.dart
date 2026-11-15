import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading your home feed',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skeleton(width: 150, height: 22),
            const SizedBox(height: Spacing.s),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: Spacing.s,
              crossAxisSpacing: Spacing.s,
              childAspectRatio: 165 / 104,
              children: const [
                Skeleton(height: 104, radius: Rounding.card),
                Skeleton(height: 104, radius: Rounding.card),
                Skeleton(height: 104, radius: Rounding.card),
                Skeleton(height: 104, radius: Rounding.card),
              ],
            ),
            const SizedBox(height: Spacing.xl),
            const Skeleton(width: 190, height: 22),
            const SizedBox(height: Spacing.l),
            const ShelfSkeleton(width: 224, height: 160),
          ],
        ),
      ),
    );
  }
}

class ShelfSkeleton extends StatelessWidget {
  const ShelfSkeleton({super.key, this.width = 156, this.height = 108});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        spacing: Spacing.gutter,
        children: [
          for (final tilt in const [-1.8, 1.6, -1.0])
            PhotoPrint(
              width: width,
              tilt: tilt,
              animate: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Spacing.xs,
                children: [
                  Skeleton(height: height, radius: 3),
                  const Skeleton(height: 14),
                  Skeleton(width: width * 0.6, height: 10),
                ],
              ),
            ),
        ],
      ).paddingOnly(left: 6),
    );
  }
}
