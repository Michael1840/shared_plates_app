import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
        child:
            Row(
              spacing: 10,
              children: [
                Expanded(child: SearchField(hint: searchHint)),
                if (hasIconButton)
                  const MyIconButton(icon: MyIcons.heart_02, padding: 14),
              ],
            ).animate().slideX(
              begin: -1,
              end: 0,
              delay: 250.ms,
              // alignment: Alignment.centerLeft,
            ),
      ),
    );
  }
}
