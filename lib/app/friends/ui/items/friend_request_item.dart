import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/methods.dart';
import '../../data/models/friendship_model.dart';

class FriendRequestItem extends StatelessWidget {
  final FriendRequestModel request;
  final bool? status;
  final void Function()? onRejectTap;
  final void Function()? onAcceptTap;
  const FriendRequestItem({
    super.key,
    required this.request,
    required this.onRejectTap,
    required this.onAcceptTap,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      radius: 16,
      child: IntrinsicHeight(
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              children: [
                Stack(
                  children: [
                    CircleAvatar(backgroundColor: context.onContainer),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      AppText.primary(text: request.fromDisplayName),
                      AppText.secondary(text: request.fromUsername),
                    ],
                  ),
                ),
                Icon(
                  MyIcons.circle_check,
                  color: status == true ? context.green : context.textSecondary,
                ).onTap(onAcceptTap),
                Icon(
                  MyIcons.stop_sign,
                  color: status == false
                      ? StatusColors.failure
                      : context.textSecondary,
                ).onTap(onRejectTap),
              ],
            ),
            Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(MyIcons.clock, size: 12, color: context.textSecondary),
                AppText.secondary(
                  text: Formatter.formatCreatedAt(request.createdAt),
                  size: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
