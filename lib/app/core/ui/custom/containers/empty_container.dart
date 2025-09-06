import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: context.onContainer,
            child: Icon(
              Icons.search_off_rounded,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          const AppText.secondary(text: 'No items found'),
        ],
      ),
    );
  }
}
