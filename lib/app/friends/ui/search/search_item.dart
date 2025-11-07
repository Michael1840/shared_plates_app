import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/buttons/small_text_button.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/utils/extensions.dart';
import '../../data/models/search_user_model.dart';

class SearchFriendItem extends StatelessWidget {
  final SearchUserModel user;
  final void Function() followUser;
  const SearchFriendItem({
    super.key,
    required this.user,
    required this.followUser,
  });

  @override
  Widget build(BuildContext context) {
    return OutlineContainer(
      radius: 16,
      child: IntrinsicHeight(
        child: Row(
          spacing: 8,
          children: [
            CircleAvatar(backgroundColor: context.onContainer),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  AppText.primary(text: user.displayName),
                  AppText.secondary(text: user.username),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                user.isFriend
                    ? const SmallTextButton(
                        text: 'Unfriend',
                        isOutlined: true,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                      )
                    : SmallTextButton(
                        text: 'Friend',
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        onTap: followUser,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
