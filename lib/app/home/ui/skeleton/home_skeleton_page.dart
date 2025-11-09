import 'package:flutter/material.dart';

import '../../../core/ui/custom/animations/loading_containers.dart';
import '../../../core/ui/layouts/page_container.dart';
import 'trending_recipe_skeleton.dart';

class HomeSkeletonPage extends StatelessWidget {
  const HomeSkeletonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: true,
      bottom: false,
      child: PageContainer.scrollable(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryLoadingContainer(width: 50, radius: 40, height: 50),
                SecondaryLoadingContainer(
                  padding: EdgeInsets.all(12),
                  radius: 40,
                  child: Row(
                    children: [PrimaryLoadingContainer(width: 16, height: 16)],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                PrimaryLoadingContainer(width: 75, height: 12),
                PrimaryLoadingContainer(width: 200, height: 20),
              ],
            ),

            SecondaryLoadingContainer(
              width: double.infinity,
              height: 60,
              radius: 16,
              padding: EdgeInsets.all(16),
              child: Row(
                spacing: 12,
                children: [
                  PrimaryLoadingContainer(width: 150, height: 14),
                  Expanded(child: SizedBox()),
                  PrimaryLoadingContainer(width: 14, height: 14),
                ],
              ),
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: SecondaryLoadingContainer(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    radius: 40,
                    child: Row(
                      spacing: 12,
                      children: [
                        PrimaryLoadingContainer(width: 14, height: 14),
                        Expanded(
                          flex: 3,
                          child: PrimaryLoadingContainer(width: 14, height: 14),
                        ),
                        Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ),
                SecondaryLoadingContainer(
                  padding: EdgeInsets.all(16),
                  radius: 40,
                  child: Row(
                    children: [PrimaryLoadingContainer(width: 14, height: 14)],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryLoadingContainer(width: 150, height: 14),
                PrimaryLoadingContainer(width: 75, height: 14),
              ],
            ),
            TrendingRecipeSkeleton(),
            TrendingRecipeSkeleton(),
            TrendingRecipeSkeleton(),
            TrendingRecipeSkeleton(),
            TrendingRecipeSkeleton(),
            TrendingRecipeSkeleton(),
          ],
        ),
      ),
    );
  }
}
