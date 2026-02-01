import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../buttons/my_icon_button.dart';
import '../containers/default_container.dart';
import '../icons/my_icons.dart';
import 'search_field.dart';

class CustomPinnedSliverSearch extends StatelessWidget {
  final String? searchHint;
  final bool hasIconButton;
  final IconData? icon;
  final void Function()? onTap;
  final void Function()? onSearchTap;
  const CustomPinnedSliverSearch({
    super.key,
    this.hasIconButton = false,
    this.searchHint,
    this.icon,
    this.onTap,
    this.onSearchTap,
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
                  MyIconButton(
                    icon: icon ?? MyIcons.heart_02,
                    padding: 16,
                    onTap: onTap,
                  ),
              ],
            ).animate().slideX(
              begin: -1,
              end: 0,
              delay: 250.ms,
              // alignment: Alignment.centerLeft,
            ),
      ).onTap(onSearchTap),
    );
  }
}

class CustomPinnedSliverSearchContainer extends StatelessWidget {
  final String? searchHint;
  final void Function()? onTap;
  final void Function()? onSearchTap;
  const CustomPinnedSliverSearchContainer({
    super.key,
    this.searchHint,
    this.onTap,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return PinnedHeaderSliver(
      child: Container(
        decoration: BoxDecoration(color: context.background),
        padding: const EdgeInsets.only(bottom: 20),
        child:
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: DefaultContainer(
                    radius: 100,
                    borderColor: context.borderSecondary,
                    child: Row(
                      spacing: 16,
                      children: [
                        Icon(
                          MyIcons.search_magnifying_glass,
                          size: 20,
                          color: context.textSecondary,
                        ),
                        Flexible(
                          child: AppText.primary(
                            text: searchHint ?? 'Search',
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().slideX(
              begin: -1,
              end: 0,
              delay: 250.ms,
              // alignment: Alignment.centerLeft,
            ),
      ).onTap(onSearchTap),
    );
  }
}
