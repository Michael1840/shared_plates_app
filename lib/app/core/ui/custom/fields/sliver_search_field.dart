import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../animations/animate_list.dart';
import '../buttons/my_icon_button.dart';
import 'search_field.dart';

class SliverSearchField extends StatelessWidget {
  final void Function()? onTap;
  const SliverSearchField({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: MySliverPersistentHeaderDelegate(
        minExtent: 68,
        maxExtent: 68,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: context.background,
                child: Row(
                  spacing: 10,
                  children: [
                    const Expanded(child: SearchField()),
                    AspectRatio(
                      aspectRatio: 1,
                      child: MyIconButton(
                        icon: Icons.add_rounded,
                        onTap: onTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      pinned: false,
    );
  }
}
