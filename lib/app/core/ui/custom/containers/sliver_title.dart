import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../animations/animate_list.dart';

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
            AppText.primary(text: subtitle),
            AppText.heading(text: title),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
