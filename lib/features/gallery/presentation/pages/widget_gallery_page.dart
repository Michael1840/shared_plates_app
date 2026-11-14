import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/floating_tab_bar.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/recipe_print_card.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/time_stamp.dart';

class WidgetGalleryPage extends StatefulWidget {
  const new({super.key});

  @override
  State<WidgetGalleryPage> createState() => _WidgetGalleryPageState();
}

class _WidgetGalleryPageState extends State<WidgetGalleryPage> {
  bool _dark = false;
  final Set<String> _chips = {'Under R100'};
  int _tab = 0;

  void _toggleChip(String label) => setState(
    () => _chips.contains(label) ? _chips.remove(label) : _chips.add(label),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _dark ? AppTheme.dark : AppTheme.light,
      child: Builder(
        builder: (context) => Scaffold(
          body: DotGridBackground(
            child: CustomScrollView(
              slivers: [
                PaprikaHeader(
                  title: 'Kitchen kit',
                  greeting: 'Widget gallery',
                  note: 'every piece,\none place',
                  actions: [
                    CircleIconButton(
                      icon: SpIcons.chevronLeft,
                      semanticLabel: 'Back',
                      onTap: () => context.pop(),
                      fill: context.sp.onHeader.withValues(alpha: 0.16),
                      color: context.sp.onHeader,
                    ),
                    CircleIconButton(
                      icon: _dark ? SpIcons.discover : SpIcons.clock,
                      semanticLabel: _dark ? 'Light mode' : 'Dark mode',
                      onTap: () => setState(() => _dark = !_dark),
                      fill: context.sp.onHeader.withValues(alpha: 0.16),
                      color: context.sp.onHeader,
                    ),
                  ],
                  search: SpSearchBar(onFilterTap: () {}),
                ).toSliver(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.gutter,
                    Spacing.xl,
                    Spacing.gutter,
                    160,
                  ),
                  sliver: SliverList.list(
                    children: [
                      const _GallerySection(
                        title: 'Type',
                        child: _TypeSamples(),
                      ),
                      const _GallerySection(
                        title: 'Paprika',
                        child: _PaprikaMoods(),
                      ),
                      _GallerySection(
                        title: 'Chips',
                        child: Wrap(
                          spacing: Spacing.xs,
                          runSpacing: Spacing.xs,
                          children: [
                            for (final label in const [
                              'Any',
                              'Under R50',
                              'Under R100',
                              'Vegetarian',
                            ])
                              SpChip(
                                label: label,
                                selected: _chips.contains(label),
                                onTap: () => _toggleChip(label),
                              ),
                          ],
                        ),
                      ),
                      const _GallerySection(
                        title: 'Photo prints',
                        child: _PrintSamples(),
                      ),
                      const _GallerySection(
                        title: 'Stamps and notes',
                        child: _StampSamples(),
                      ),
                      const _GallerySection(
                        title: 'Sticky note',
                        child: StickyNote(
                          title: 'Want a nudge when someone saves your recipe?',
                          body: "That's all we'll use it for.",
                        ),
                      ),
                      const _GallerySection(
                        title: 'Covers',
                        child: _CoverSamples(),
                      ),
                      const _GallerySection(
                        title: 'Loading',
                        child: _SkeletonSamples(),
                      ),
                      _GallerySection(
                        title: 'Buttons',
                        child: Column(
                          spacing: Spacing.s,
                          children: [
                            PrimaryButton(label: 'Start cooking', onTap: () {}),
                            PrimaryButton(
                              label: 'Share',
                              busyLabel: 'Sharing…',
                              isBusy: true,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          extendBody: true,
          bottomNavigationBar: FloatingTabBar(
            items: const [
              TabItem(label: 'Home', icon: SpIcons.home),
              TabItem(label: 'Discover', icon: SpIcons.discover),
              TabItem(label: 'Recipes', icon: SpIcons.recipes),
              TabItem(label: 'Friends', icon: SpIcons.friends),
            ],
            currentIndex: _tab,
            onSelect: (i) => setState(() => _tab = i),
            onCreate: () {},
          ),
        ),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const new({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        const SizedBox(height: Spacing.s),
        child,
      ],
    ).paddingOnly(bottom: Spacing.xl);
  }
}

class _TypeSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xs,
      children: [
        AppText(text: "Gran's chakalaka", config: FontConfigs.title),
        AppText(text: 'Trending this week', config: FontConfigs.h2),
        AppText(text: 'Cape Malay chicken curry', config: FontConfigs.h4),
        AppText(
          text: 'Heat the oil in a big pan and fry the onion until soft.',
          config: FontConfigs.body1,
        ),
        AppText.secondary(
          text: 'Aisha P. · viewed yesterday',
          config: FontConfigs.sublabel1,
        ),
        HandwrittenNote("Lerato's. Feeds 4 for R148!", large: true),
      ],
    );
  }
}

class _PaprikaMoods extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        for (final mood in PaprikaMood.values)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Paprika(mood: mood, size: 76),
              AppText.secondary(text: mood.name, config: FontConfigs.sublabel2),
            ],
          ),
      ],
    );
  }
}

class _PrintSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        spacing: Spacing.gutter,
        children: [
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
          ),
          RecipePrintCard(
            title: 'Sticky braai chops',
            coverStyle: CoverStyle.meat,
            note: 'Riaan swears by these',
            minutes: 40,
            likes: 191,
            priceLabel: 'R52 a plate',
            tilt: 1.6,
            tapeTilt: -4,
            onTap: () {},
            onSave: () {},
          ),
        ],
      ).paddingOnly(top: Spacing.m, bottom: Spacing.l, left: 6),
    );
  }
}

class _StampSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: Spacing.l,
      children: [
        TimeStamp(minutes: 55, large: true),
        TimeStamp(minutes: 20),
        HandwrittenNote('where were we?', tilt: -3),
      ],
    );
  }
}

class _CoverSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.s,
      runSpacing: Spacing.s,
      children: [
        for (final style in CoverStyle.values)
          RecipeCover(
            style: style,
            width: 100,
            height: 75,
            radius: Rounding.chip,
          ),
      ],
    );
  }
}

class _SkeletonSamples extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Spacing.xs,
      children: [Skeleton(height: 64, radius: 14), Skeleton(width: 220)],
    );
  }
}
