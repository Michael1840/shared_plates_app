import 'package:flutter/material.dart';

import '../../../core/ui/custom/animations/loading_containers.dart';

class RecipeItemSkeleton extends StatelessWidget {
  const RecipeItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SecondaryLoadingContainer(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      radius: 24,
      child: IntrinsicHeight(
        child: Row(
          spacing: 12,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PrimaryLoadingContainer(
                width: double.infinity,
                height: double.infinity,
                radius: 16,
              ),
            ),
            Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryLoadingContainer(width: 100, height: 14),
                PrimaryLoadingContainer(width: 75, height: 10),
                SizedBox(),
                Row(
                  spacing: 8,
                  children: [
                    PrimaryLoadingContainer(width: 30, height: 14),
                    PrimaryLoadingContainer(width: 50, height: 14),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryLoadingContainer(width: 30, height: 14),
                  PrimaryLoadingContainer(width: 20, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
