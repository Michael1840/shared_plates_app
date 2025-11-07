import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';

class EmptyContainer extends StatelessWidget {
  final IconData? icon;
  const EmptyContainer({super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: context.container,
            radius: 40,
            child: Icon(
              icon ?? Icons.search_off_rounded,
              color: context.textSecondary,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const AppText.primary(text: 'We couldn\'t find any items'),
          const SizedBox(height: 8),
          const AppText.secondary(
            text: 'Start typing to search for the items you want.',
            size: 10,
          ),
        ],
      ),
    );
  }
}
