import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/utils/extensions.dart';
import '../../data/models/friendship_model.dart';

class FriendItem extends StatelessWidget {
  final FriendRequestModel friend;
  const FriendItem({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      radius: 24,
      child: IntrinsicHeight(
        child: Row(
          spacing: 8,
          children: [
            Stack(
              children: [
                CircleAvatar(backgroundColor: context.onContainer),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    maxRadius: 8,
                    backgroundColor: context.container,
                    child: CircleAvatar(
                      maxRadius: 5,
                      backgroundColor: friend.fromUser.isOnline
                          ? context.green
                          : context.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  AppText.primary(text: friend.fromUser.displayName),
                  AppText.secondary(text: friend.fromUser.username),
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
