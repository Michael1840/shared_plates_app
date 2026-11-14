import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/avatar.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/status_note.dart';
import 'package:shared_plates_app/features/activity/data/activity_repository.dart';
import 'package:shared_plates_app/features/activity/presentation/bloc/activity_cubit.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/browse/presentation/bloc/feed_slice.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';

class ActivityPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<SessionCubit>().state.userId ?? '';
    return BlocProvider(
      create: (_) {
        final cubit = ActivityCubit(
          activity: sl<ActivityRepository>(),
          friends: sl<FriendsRepository>(),
          userId: uid,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const ActivityView(),
    );
  }
}

class ActivityView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ActivityCubit>().state;
    final cubit = context.read<ActivityCubit>();
    final fresh = state.fresh;
    final earlier = state.earlier;
    return BlocListener<ActivityCubit, ActivityState>(
      listenWhen: (a, b) => a.errorTick != b.errorTick,
      listener: (context, s) {
        final error = s.error;
        if (error != null) context.showSnackBarError(error);
      },
      child: Scaffold(
        body: DotGridBackground(
          child: RefreshIndicator(
            color: context.primary,
            backgroundColor: context.container,
            onRefresh: cubit.load,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _ActivityHeader(newCount: fresh.length).toSliver(),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    Spacing.gutter,
                    Spacing.l,
                    Spacing.gutter,
                    MediaQuery.paddingOf(context).bottom + Spacing.l,
                  ),
                  sliver: SliverList.list(
                    children: [
                      if (state.items.isStale)
                        StatusNote.offline().paddingOnly(bottom: Spacing.l),
                      if (state.items.isInProgress || state.items.isIdle)
                        const _ActivitySkeleton()
                      else if (state.items.isError)
                        EmptyState(
                          mood: PaprikaMood.oops,
                          title: BrowseMessages.titleFor(state.items.error),
                          body: state.items.error ?? '',
                          actions: [
                            CompactButton(
                              label: 'Try again',
                              onTap: cubit.load,
                            ),
                          ],
                        )
                      else if (state.all.isEmpty)
                        const EmptyState(
                          title: 'All quiet',
                          body:
                              'When someone saves or cooks your recipes, or '
                              "wants to be friends, you'll see it here.",
                        )
                      else ...[
                        if (fresh.isNotEmpty)
                          _Group(title: 'New', items: fresh),
                        if (earlier.isNotEmpty)
                          _Group(title: 'Earlier', items: earlier),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  const new({required this.newCount});

  final int newCount;

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    return HeaderBlock(
      radius: 36,
      bottomPadding: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeaderIconButton(
                icon: SpIcons.chevronLeft,
                semanticLabel: 'Back',
                onTap: () => context.pop(),
              ),
              const Spacer(),
              HeaderIconButton(
                icon: SpIcons.settings,
                semanticLabel: 'Notification settings',
                onTap: () => context.push(Routes.settings),
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: Spacing.s,
            children: [
              Entrance(
                delay: const Duration(milliseconds: 60),
                child: Semantics(
                  header: true,
                  child: AppText(
                    text: 'Activity',
                    config: FontConfigs.title,
                    color: ink,
                  ),
                ),
              ),
              HandwrittenNote(
                newCount == 0 ? "you're all caught up" : '$newCount new',
                surface: NoteSurface.header,
                tilt: -3,
              ).paddingOnly(bottom: 4),
            ],
          ).paddingOnly(top: 10),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const new({required this.title, required this.items});

  final String title;
  final List<ActivityItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        SectionHeader(title: title),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(Rounding.card),
          ),
          child: Column(
            children: [
              for (final (i, item) in items.indexed)
                ActivityRow(item: item, last: i == items.length - 1),
            ],
          ),
        ),
        const SizedBox(height: Spacing.l),
      ],
    );
  }
}

class ActivityRow extends StatelessWidget {
  const new({required this.item, required this.last, super.key});

  final ActivityItem item;
  final bool last;

  static String describe(ActivityItem item) {
    final title = item.recipe?.title ?? 'your recipe';
    return switch (item.kind) {
      NotificationKind.recipeSaved => 'saved $title.',
      NotificationKind.recipeCooked => 'cooked your $title.',
      NotificationKind.friendRequest => 'wants to be friends.',
      NotificationKind.friendAccepted => 'accepted your friend request.',
      NotificationKind.weeklyRoundup => _roundup(item.data),
    };
  }

  static String _roundup(Map<String, dynamic> data) {
    final saves = (data['saves'] as num?)?.toInt() ?? 0;
    final cooks = (data['cooks'] as num?)?.toInt() ?? 0;
    final parts = [
      if (saves > 0) '$saves ${saves == 1 ? 'save' : 'saves'}',
      if (cooks > 0) '$cooks ${cooks == 1 ? 'cook' : 'cooks'}',
    ];
    return parts.isEmpty
        ? 'A quiet week. Share something new?'
        : '${parts.join(' and ')} of your recipes this week.';
  }

  static String when(DateTime at, DateTime now) {
    final diff = now.difference(at);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    }
    return Formatters.relativeDayLabel(at.toLocal(), now);
  }

  @override
  Widget build(BuildContext context) {
    final actor = item.actor;
    final recipe = item.recipe;
    final state = context.watch<ActivityCubit>().state;
    final answered = actor == null ? null : state.answered[actor.id];
    final busy = actor != null && state.busy.contains(actor.id);
    final isRequest =
        item.kind == NotificationKind.friendRequest && actor != null;
    final roundup = item.kind == NotificationKind.weeklyRoundup;
    final who = roundup ? 'Your week.' : actor?.firstName ?? 'Someone';
    return Pressable(
      isButton: false,
      onTap: () {
        if (recipe != null) {
          unawaited(context.openRecipe(recipe));
        } else if (actor != null) {
          unawaited(context.openPerson(actor.id));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: context.sp.progressTrack)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Spacing.s,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Spacing.s,
              children: [
                if (roundup || actor == null)
                  const Paprika(
                    mood: PaprikaMood.proud,
                    size: 44,
                    decorative: true,
                    animate: false,
                  )
                else
                  Avatar(name: actor.displayName, seed: actor.id),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    AppRichText(
                      config: FontConfigs.body3,
                      spans: [
                        TextSpan(
                          text: '$who ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: describe(item)),
                      ],
                    ),
                    AppText.secondary(
                      text: roundup
                          ? 'Weekly round-up'
                          : when(item.createdAt, DateTime.now()),
                      config: FontConfigs.sublabel2,
                      color: context.textMuted,
                    ),
                  ],
                ).expand(),
                if (recipe != null)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: context.container,
                      borderRadius: BorderRadius.circular(Rounding.photo),
                      boxShadow: [
                        BoxShadow(
                          color: context.sp.printShadow,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: RecipeCover(
                      style: recipe.coverStyle,
                      imageUrl: recipe.coverUrl,
                      localPath: recipe.localCoverPath,
                      width: 44,
                      height: 44,
                      radius: 2,
                    ),
                  ).rotated(3),
                if (item.unread)
                  Semantics(
                    label: 'New',
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: context.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            if (isRequest)
              _RequestActions(
                personId: actor.id,
                answered: answered,
                busy: busy,
              ),
          ],
        ),
      ),
    );
  }
}

class _RequestActions extends StatelessWidget {
  const new({
    required this.personId,
    required this.answered,
    required this.busy,
  });

  final String personId;
  final bool? answered;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final done = answered;
    if (done != null) {
      return AppText.secondary(
        text: done ? 'You are now friends.' : 'Request declined.',
        config: FontConfigs.sublabel1,
      ).paddingOnly(left: 56);
    }
    final cubit = context.read<ActivityCubit>();
    return Row(
      spacing: Spacing.xs,
      children: [
        const SizedBox(width: 48),
        CompactButton(
          label: busy ? 'One sec…' : 'Accept',
          onTap: busy ? null : () => cubit.answer(personId, accept: true),
        ),
        TextLinkButton(
          label: 'Not now',
          color: context.textSecondary,
          onTap: busy ? null : () => cubit.answer(personId, accept: false),
        ),
      ],
    );
  }
}

class _ActivitySkeleton extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: Column(
        spacing: Spacing.s,
        children: [
          Skeleton(width: 80, height: 22),
          Skeleton(height: 220, radius: Rounding.card),
        ],
      ),
    );
  }
}
