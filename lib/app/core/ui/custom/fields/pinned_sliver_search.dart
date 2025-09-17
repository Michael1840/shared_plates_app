import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../buttons/my_icon_button.dart';
import '../icons/my_icons.dart';
import 'search_field.dart';

class CustomPinnedSliverSearch extends StatelessWidget {
  final String? searchHint;
  final bool hasIconButton;
  const CustomPinnedSliverSearch({
    super.key,
    this.hasIconButton = false,
    this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return PinnedHeaderSliver(
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        color: context.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(child: SearchField(hint: searchHint)),
                if (hasIconButton)
                  const MyIconButton(icon: MyIcons.heart_02, padding: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
