import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../animations/animate_list.dart';
import '../buttons/create_recipe_button.dart';

class CustomSliverTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const CustomSliverTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: MySliverPersistentHeaderDelegate(
        minExtent: 0,
        maxExtent: 63,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText.primary(text: subtitle).animate().slideX(
              begin: -1,
              end: 0,
              delay: 250.ms,
              // alignment: Alignment.centerLeft,
            ),
            AppText.heading(text: title).animate().slideX(
              begin: -1,
              end: 0,
              delay: 500.ms,
              // alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomSliverImageButton extends StatelessWidget {
  final ButtonType type;
  final void Function()? onTap;
  const CustomSliverImageButton({super.key, required this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: MySliverPersistentHeaderDelegate(
        minExtent: 0,
        maxExtent: 80,
        child: CreateRecipeButton(type: type, onTap: onTap)
            .paddingBottom(20)
            .animate()
            .slideX(
              begin: 1,
              end: 0,
              delay: 250.ms,
              // alignment: Alignment.centerLeft,
            ),
      ),
    );
  }
}
