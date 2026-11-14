import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    return TabPage(
      header: PaprikaHeader(
        greeting: 'Good evening',
        title: "What's cooking tonight?",
        note: 'braai weather,\njust saying',
        actions: [
          CircleIconButton(
            icon: SpIcons.bell,
            semanticLabel: 'Activity',
            onTap: () {},
            fill: sp.onHeader.withValues(alpha: 0.16),
            color: sp.onHeader,
            badgeBorder: sp.header,
          ),
        ],
        search: SpSearchBar(onTap: () {}, onFilterTap: () {}),
      ),
      children: [
        const StickyNote(
          title: 'Fresh start.',
          body: 'Recipes from your people will land here soon.',
          mood: PaprikaMood.happy,
        ),
        if (Env.isDev)
          TextLinkButton(
            label: 'Open widget gallery',
            onTap: () => context.push(Routes.gallery),
          ).paddingOnly(top: Spacing.l),
      ],
    );
  }
}
