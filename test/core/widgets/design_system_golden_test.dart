@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/floating_tab_bar.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/recipe_print_card.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/time_stamp.dart';

import '../../helpers/golden.dart';

void main() {
  for (final theme in GoldenTheme.values) {
    group('${theme.name} theme', () {
      testWidgets('paprika header', (tester) async {
        await pumpGolden(
          tester,
          PaprikaHeader(
            greeting: 'Good evening, Thandi',
            title: "What's cooking tonight?",
            note: 'braai weather,\njust saying',
            actions: [
              CircleIconButton(
                icon: SpIcons.bell,
                semanticLabel: 'Activity',
                onTap: () {},
              ),
            ],
            search: SpSearchBar(onFilterTap: () {}),
          ),
          theme: theme,
          size: const Size(390, 360),
          padding: EdgeInsets.zero,
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/paprika_header.png'),
        );
      });

      testWidgets('friends header', (tester) async {
        await pumpGolden(
          tester,
          const PaprikaHeader(
            title: 'Friends',
            note: 'your kitchen crew',
            mood: PaprikaMood.cheer,
            tone: HeaderTone.herb,
          ),
          theme: theme,
          size: const Size(390, 260),
          padding: EdgeInsets.zero,
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/friends_header.png'),
        );
      });

      testWidgets('chips', (tester) async {
        await pumpGolden(
          tester,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SpChip(label: 'Any', selected: false, onTap: () {}),
              SpChip(label: 'Under R100', selected: true, onTap: () {}),
              SpChip(label: 'Vegetarian', selected: false, onTap: () {}),
            ],
          ),
          theme: theme,
          size: const Size(390, 120),
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/chips.png'),
        );
      });

      testWidgets('recipe print card', (tester) async {
        await pumpGolden(
          tester,
          RecipePrintCard(
            title: 'Cape Malay chicken curry',
            coverStyle: CoverStyle.stew,
            note: 'Feeds 4 for R148!',
            minutes: 55,
            likes: 284,
            priceLabel: 'R37 a plate',
            isSaved: true,
            tapeTilt: 3,
            onTap: () {},
            onSave: () {},
          ).paddedForTilt(),
          theme: theme,
          size: const Size(320, 380),
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/recipe_print_card.png'),
        );
      });

      testWidgets('stamps', (tester) async {
        await pumpGolden(
          tester,
          const Row(
            children: [
              TimeStamp(minutes: 55, large: true),
              SizedBox(width: 24),
              TimeStamp(minutes: 20),
              SizedBox(width: 24),
              TimeStamp(minutes: 180),
            ],
          ),
          theme: theme,
          size: const Size(390, 140),
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/stamps.png'),
        );
      });

      testWidgets('sticky note', (tester) async {
        await pumpGolden(
          tester,
          SizedBox(
            width: 350,
            child: StickyNote(
              title: 'Want a nudge when someone saves your recipe?',
              body: "That's all we'll use it for.",
              actions: [PrimaryButton(label: 'Turn on', onTap: () {})],
            ),
          ),
          theme: theme,
          size: const Size(390, 240),
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/sticky_note.png'),
        );
      });

      testWidgets('buttons and skeleton', (tester) async {
        await pumpGolden(
          tester,
          SizedBox(
            width: 350,
            child: Column(
              spacing: 12,
              children: [
                PrimaryButton(label: 'Start cooking', onTap: () {}),
                PrimaryButton(
                  label: 'Share',
                  busyLabel: 'Sharing…',
                  isBusy: true,
                  onTap: () {},
                ),
                const Skeleton(height: 64, radius: 14),
                const Skeleton(width: 220),
              ],
            ),
          ),
          theme: theme,
          size: const Size(390, 300),
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/buttons_skeleton.png'),
        );
      });

      testWidgets('floating tab bar', (tester) async {
        await pumpGolden(
          tester,
          SizedBox(
            width: 390,
            child: FloatingTabBar(
              items: const [
                TabItem(label: 'Home', icon: SpIcons.home),
                TabItem(label: 'Discover', icon: SpIcons.discover),
                TabItem(label: 'Recipes', icon: SpIcons.recipes),
                TabItem(label: 'Friends', icon: SpIcons.friends),
              ],
              currentIndex: 0,
              onSelect: (_) {},
              onCreate: () {},
            ),
          ),
          theme: theme,
          size: const Size(390, 120),
          padding: EdgeInsets.zero,
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${theme.name}/tab_bar.png'),
        );
      });
    });
  }
}

extension on Widget {
  Widget paddedForTilt() =>
      Padding(padding: const EdgeInsets.fromLTRB(12, 16, 24, 24), child: this);
}
