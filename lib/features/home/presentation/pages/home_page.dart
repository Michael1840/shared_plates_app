import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/domain/search_filters.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/status_note.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';
import 'package:shared_plates_app/features/activity/presentation/bloc/activity_cubit.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/widgets/browse_skeletons.dart';
import 'package:shared_plates_app/features/browse/presentation/widgets/card_print.dart';
import 'package:shared_plates_app/features/browse/presentation/widgets/mood_tile.dart';
import 'package:shared_plates_app/features/browse/presentation/widgets/recipe_row_card.dart';
import 'package:shared_plates_app/features/home/data/checklist_repository.dart';
import 'package:shared_plates_app/features/home/presentation/bloc/checklist_cubit.dart';
import 'package:shared_plates_app/features/home/presentation/bloc/home_cubit.dart';
import 'package:shared_plates_app/features/home/presentation/widgets/first_run_checklist.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/search/presentation/widgets/filter_sheet.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final uid = session.userId;
    return MultiBlocProvider(
      key: ValueKey(uid),
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = ChecklistCubit(sl<ChecklistRepository>());
            if (uid != null && session.status == SessionStatus.signedIn) {
              cubit.watch(uid);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = HomeCubit(
              browse: sl<BrowseRepository>(),
              profiles: sl<ProfileRepository>(),
              userId: uid,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const new();

  static String greetingFor(DateTime now, String? name) {
    final hour = now.hour;
    final part = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    final first = name?.trim().split(RegExp(r'\s+')).first;
    return first == null || first.isEmpty ? part : '$part, $first';
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final profile = context.watch<CurrentProfileCubit>().state;
    final checklist = context.watch<ChecklistCubit>().state;
    final home = context.watch<HomeCubit>().state;
    final guest = session.status == SessionStatus.guest;
    final firstRun =
        checklist != null && !checklist.dismissed && !checklist.complete;
    if (firstRun && home.picks.isIdle) {
      unawaited(context.read<HomeCubit>().loadPicks());
    }
    return TabPage(
      onRefresh: () => context.read<HomeCubit>().load(),
      header: PaprikaHeader(
        greeting: guest
            ? 'Welcome'
            : greetingFor(DateTime.now(), profile?.displayName),
        title: "What's cooking tonight?",
        note: home.isLoading
            ? 'stirring the pot...'
            : 'braai weather,\njust saying',
        mood: home.isLoading ? PaprikaMood.thinking : PaprikaMood.happy,
        actions: [
          if (!guest) _ActivityBell(userId: session.userId),
          _AvatarButton(profile: profile, guest: guest),
        ],
        search: SpSearchBar(
          onTap: () => unawaited(context.openSearch()),
          onFilterTap: () async {
            final filters = await context.showFilters(const SearchFilters());
            if (filters != null && context.mounted) {
              await context.openSearch(filters);
            }
          },
        ),
      ),
      children: [
        if (guest)
          StickyNote(
            title: 'Just looking?',
            body: 'Sign in to save recipes and share your own.',
            actions: [
              CompactButton(
                label: 'Sign in',
                onTap: () => context.read<SessionCubit>().leaveGuest(),
              ),
            ],
          ).paddingOnly(bottom: Spacing.l),
        if (home.isStale) StatusNote.offline().paddingOnly(bottom: Spacing.l),
        if (home.isLoading)
          const HomeSkeleton()
        else if (home.failedEverything)
          EmptyState(
            mood: PaprikaMood.oops,
            title: BrowseMessages.titleFor(home.error),
            body: home.error ?? '',
            actions: [
              CompactButton(
                label: 'Try again',
                onTap: () => context.read<HomeCubit>().load(),
              ),
            ],
          )
        else if (firstRun)
          _FirstRunSection(progress: checklist, home: home)
        else
          _EverydaySection(home: home),
      ],
    );
  }
}

class _FirstRunSection extends StatelessWidget {
  const new({required this.progress, required this.home});

  final ChecklistProgress progress;
  final HomeState home;

  @override
  Widget build(BuildContext context) {
    final picks = home.picks.value?.value ?? const [];
    final note = home.pickLabels.isEmpty
        ? 'a few favourites'
        : home.pickLabels.join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FirstRunChecklist(
          progress: progress,
          onDismiss: () => context.read<ChecklistCubit>().dismiss(),
        ),
        const SizedBox(height: Spacing.l),
        SectionHeader(title: 'Picked for you', note: note),
        if (home.picks.isInProgress)
          const ShelfSkeleton(
            width: 210,
            height: 140,
          ).paddingOnly(top: Spacing.m)
        else if (picks.isNotEmpty)
          _PrintShelf(
            children: [
              for (final (i, card) in picks.indexed)
                CardPrint(
                  card: card,
                  index: i,
                  width: 210,
                  photoHeight: 140,
                  showStats: false,
                ),
            ],
          ),
      ],
    );
  }
}

class _EverydaySection extends StatelessWidget {
  const new({required this.home});

  final HomeState home;

  @override
  Widget build(BuildContext context) {
    final moods = home.moods.value?.value ?? const [];
    final trending = home.trending.value?.value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (moods.isNotEmpty) ...[
          const Entrance(
            delay: Duration(milliseconds: 160),
            child: SectionHeader(title: 'Cook by mood'),
          ),
          const SizedBox(height: Spacing.s),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: Spacing.s,
            crossAxisSpacing: Spacing.s,
            childAspectRatio: 165 / 104,
            children: [
              for (final (i, mood) in moods.take(4).indexed)
                Entrance.staggered(
                  index: i,
                  base: const Duration(milliseconds: 180),
                  child: MoodTile(
                    collection: mood,
                    index: i,
                    onTap: () => unawaited(
                      context.openSearch(
                        SearchFilters.fromCollection(
                          mood.filter,
                          title: mood.title,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Spacing.xl),
        ],
        if (trending.isNotEmpty) ...[
          Entrance(
            delay: const Duration(milliseconds: 240),
            child: SectionHeader(
              title: 'Trending this week',
              actionLabel: 'See all',
              onAction: () => unawaited(context.openSearch()),
            ),
          ),
          _PrintShelf(
            children: [
              for (final (i, card) in trending.indexed)
                CardPrint(card: card, index: i),
            ],
          ),
          const SizedBox(height: Spacing.l),
        ] else if (home.trending.isSuccessful)
          const StickyNote(
            title: 'Quiet week.',
            body: 'Save or cook something and it could trend here.',
            mood: PaprikaMood.sleepy,
          ).paddingOnly(bottom: Spacing.l),
        if (home.recent.isNotEmpty) ...[
          const Entrance(
            delay: Duration(milliseconds: 320),
            child: SectionHeader(title: 'Jump back in', note: 'where were we?'),
          ),
          const SizedBox(height: Spacing.s),
          for (final (i, recent) in home.recent.indexed)
            Entrance.staggered(
              index: i,
              base: const Duration(milliseconds: 260),
              child: RecipeRowCard(
                card: recent.card,
                compact: true,
                subtitle: _recentLine(recent),
                onTap: () => unawaited(context.openRecipe(recent.card)),
              ),
            ).paddingOnly(bottom: Spacing.s),
        ],
      ],
    );
  }

  static String _recentLine(RecentRecipe recent) {
    final who = recent.card.isMine
        ? 'Your recipe'
        : Formatters.shortName(recent.card.authorName);
    final when = Formatters.relativeDay(recent.viewedAt, DateTime.now());
    return '$who · viewed $when';
  }
}

class _PrintShelf extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.fromLTRB(6, Spacing.m, Spacing.gutter, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Spacing.gutter,
        children: children,
      ),
    );
  }
}

class _ActivityBell extends StatefulWidget {
  const new({required this.userId});

  final String? userId;

  @override
  State<_ActivityBell> createState() => _ActivityBellState();
}

class _ActivityBellState extends State<_ActivityBell> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<ActivityBadgeCubit>().refresh(widget.userId));
  }

  Future<void> _open() async {
    final badge = context.read<ActivityBadgeCubit>()..clear();
    await context.push<void>(Routes.activity);
    if (mounted) await badge.refresh(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final unread = context.watch<ActivityBadgeCubit>().state;
    return HeaderIconButton(
      icon: SpIcons.bell,
      semanticLabel: unread > 0 ? 'Activity, $unread new' : 'Activity',
      badge: unread > 0,
      onTap: () => unawaited(_open()),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const new({required this.profile, required this.guest});

  final Profile? profile;
  final bool guest;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final initials = Formatters.initials(profile?.displayName);
    return Pressable(
      semanticLabel: guest ? 'Sign in' : 'Your account',
      onTap: () {
        if (guest) {
          unawaited(context.read<SessionCubit>().leaveGuest());
          return;
        }
        unawaited(context.push(Routes.profile));
      },
      child: Container(
        width: Sizes.minTap,
        height: Sizes.minTap,
        decoration: BoxDecoration(color: sp.onHeader, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: initials.isEmpty || guest
            ? SpIcon(SpIcons.friends, size: 20, color: sp.primaryDeep)
            : AppText(
                text: initials,
                config: FontConfigs.body2,
                weight: FontWeight.w700,
                color: context.isDark ? sp.header : sp.primaryDeep,
              ),
      ),
    );
  }
}
