import 'package:flutter/material.dart';

import '../../../core/ui/custom/animations/loading_containers.dart';

class TrendingRecipeSkeleton extends StatelessWidget {
  const TrendingRecipeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SecondaryLoadingContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      radius: 24,
      child: Column(
        spacing: 20,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const AspectRatio(
              aspectRatio: 5 / 3,
              child: PrimaryLoadingContainer(
                width: double.infinity,
                height: double.infinity,
                radius: 16,
              ),
            ),
          ),
          const IntrinsicHeight(
            child: Row(
              spacing: 12,
              children: [
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
                    spacing: 40,
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
        ],
      ),
    );
  }
}
