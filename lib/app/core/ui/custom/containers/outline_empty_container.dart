import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../icons/my_icons.dart';
import 'default_container.dart';

class OutlineEmptyContainer extends StatelessWidget {
  final String emptyText;
  const OutlineEmptyContainer({super.key, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    return OutlineContainer(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MyIcons.magnifying_glass_minus,
            color: context.textSecondary,
            size: 28,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [AppText.secondary(text: emptyText)],
          ),
        ],
      ),
    );
  }
}
