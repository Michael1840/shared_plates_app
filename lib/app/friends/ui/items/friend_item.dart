import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/utils/extensions.dart';

class FriendItem extends StatelessWidget {
  final bool isOnline;
  const FriendItem({super.key, this.isOnline = false});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      radius: 16,
      child: IntrinsicHeight(
        child: Row(
          spacing: 8,
          children: [
            Stack(
              children: [
                CircleAvatar(backgroundColor: context.onContainer),
                Positioned(
                  child: CircleAvatar(
                    maxRadius: 8,
                    backgroundColor: context.container,
                    child: CircleAvatar(
                      maxRadius: 5,
                      backgroundColor: isOnline
                          ? context.green
                          : context.textSecondary,
                    ),
                  ),
                  bottom: 0,
                  right: 0,
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  AppText.primary(text: 'Friend Name'),
                  AppText.secondary(text: '@test_name'),
                ],
              ),
            ),
            Icon(Icons.more_vert_rounded, color: context.textPrimary),
          ],
        ),
      ),
    );
  }
}
