import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/avatar.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/tape.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/friends/domain/person.dart';
import 'package:shared_plates_app/features/friends/presentation/bloc/friends_cubit.dart';

class RequestsSection extends StatelessWidget {
  const new({required this.requests, super.key});

  final List<Friendship> requests;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.xs,
      children: [
        Row(
          spacing: Spacing.xs,
          children: [
            Semantics(
              header: true,
              child: const AppText(text: 'Requests', config: FontConfigs.h2),
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 22),
              height: 22,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: AppText(
                text: '${requests.length}',
                config: FontConfigs.sublabel2,
                weight: FontWeight.w700,
                color: context.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (final r in requests) RequestCard(person: r.person),
        const SizedBox(height: Spacing.l),
      ],
    );
  }
}

class RequestCard extends StatelessWidget {
  const new({required this.person, super.key});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final busy = context.select<FriendsCubit, bool>(
      (c) => c.state.busy.contains(person.id),
    );
    final cubit = context.read<FriendsCubit>();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(Rounding.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s,
        children: [
          Pressable(
            isButton: false,
            onTap: () => unawaited(context.openPerson(person.id)),
            child: Row(
              spacing: Spacing.s,
              children: [
                Avatar(name: person.displayName, seed: person.id),
                _NameBlock(person: person, detail: 'wants to be friends'),
              ],
            ),
          ),
          Row(
            spacing: Spacing.xs,
            children: [
              _PillButton(
                label: busy ? 'Adding…' : 'Accept',
                primary: true,
                onTap: busy ? null : () => cubit.accept(person.id),
              ).expand(),
              _PillButton(
                label: 'Not now',
                onTap: busy ? null : () => cubit.decline(person.id),
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const new({required this.label, required this.onTap, this.primary = false});

  final String label;
  final VoidCallback? onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: Sizes.minTap,
        decoration: BoxDecoration(
          color: primary ? context.primary : context.container,
          borderRadius: BorderRadius.circular(Rounding.pill),
          border: primary
              ? null
              : Border.all(color: context.sp.fieldBorder, width: 1.5),
        ),
        alignment: Alignment.center,
        child: AppText(
          text: label,
          config: FontConfigs.button2,
          color: primary ? context.onPrimary : context.textPrimary,
        ),
      ),
    );
  }
}

class _NameBlock extends StatelessWidget {
  const new({required this.person, this.detail});

  final Person person;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final extra = detail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 1,
      children: [
        AppText(
          text: person.displayName,
          config: FontConfigs.body2,
          weight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppText.secondary(
          text: extra == null
              ? '@${person.username}'
              : '@${person.username} · $extra',
          config: FontConfigs.sublabel1,
          color: context.textMuted,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ).expand();
  }
}

class JustCooked extends StatelessWidget {
  const new({required this.cards, super.key});

  final List<RecipeCard> cards;

  static const _tilts = [-2.0, 1.6, -1.2, 1.4];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Just shared',
          note: 'fresh from their kitchens',
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          padding: const EdgeInsets.fromLTRB(4, 12, 0, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.m,
            children: [
              for (final (i, c) in cards.take(10).indexed)
                Entrance.staggered(
                  index: i,
                  style: EntranceStyle.print,
                  child: _CookedPrint(card: c, tilt: _tilts[i % _tilts.length]),
                ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.l),
      ],
    );
  }
}

class _CookedPrint extends StatelessWidget {
  const new({required this.card, required this.tilt});

  final RecipeCard card;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    final first = (card.authorName ?? '').trim().split(RegExp(r'\s+')).first;
    final label = first.isEmpty ? card.title : "$first's ${_short(card.title)}";
    return Pressable(
      onTap: () => unawaited(context.openRecipe(card)),
      semanticLabel: '${card.title} by ${card.authorName ?? 'a friend'}',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 136,
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
            decoration: BoxDecoration(
              color: context.container,
              borderRadius: BorderRadius.circular(Rounding.printSmall),
              boxShadow: [
                BoxShadow(
                  color: context.sp.printShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 4,
              children: [
                RecipeCover(
                  style: card.coverStyle,
                  imageUrl: card.coverUrl,
                  localPath: card.localCoverPath,
                  height: 100,
                  radius: 2,
                ),
                HandwrittenNote(
                  label,
                  animate: false,
                ).paddingOnly(left: 2, right: 2, top: 2),
              ],
            ),
          ),
          const Positioned(
            top: -9,
            left: 0,
            right: 0,
            child: Center(child: Tape(width: 48, height: 16)),
          ),
        ],
      ).rotated(tilt),
    );
  }

  static String _short(String title) {
    final words = title.trim().split(RegExp(r'\s+'));
    return (words.length <= 2 ? words : words.skip(words.length - 2))
        .join(' ')
        .toLowerCase();
  }
}

class FriendList extends StatelessWidget {
  const new({required this.overview, super.key});

  final FriendsOverview overview;

  @override
  Widget build(BuildContext context) {
    final week = DateTime.now().subtract(const Duration(days: 7));
    final friends = overview.friends;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SectionHeader(title: 'Your friends · ${friends.length}').expand(),
            AppText.secondary(
              text: 'Newest recipes first',
              config: FontConfigs.sublabel1,
              color: context.textMuted,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(Rounding.card),
          ),
          child: Column(
            children: [
              for (final (i, f) in friends.indexed)
                _FriendRow(
                  person: f.person,
                  fresh: overview.newFrom(f.person.id, week),
                  last: i == friends.length - 1,
                ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.l),
      ],
    );
  }
}

class _FriendRow extends StatelessWidget {
  const new({required this.person, required this.fresh, required this.last});

  final Person person;
  final int fresh;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      isButton: false,
      onTap: () => unawaited(context.openPerson(person.id)),
      semanticLabel: [
        person.displayName,
        if (fresh > 0) '$fresh new recipes',
      ].join(', '),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: context.sp.progressTrack)),
        ),
        child: Row(
          spacing: Spacing.s,
          children: [
            Avatar(name: person.displayName, seed: person.id, size: 40),
            _NameBlock(person: person),
            if (fresh > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Palette.sage,
                  borderRadius: BorderRadius.circular(Rounding.pill),
                ),
                child: AppText(
                  text: '$fresh new',
                  config: FontConfigs.sublabel2,
                  weight: FontWeight.w700,
                  color: Palette.sageInk,
                ),
              ),
            SpIcon(SpIcons.chevronRight, size: 18, color: context.sp.chevron),
          ],
        ),
      ),
    );
  }
}

class SentRequests extends StatelessWidget {
  const new({required this.sent, super.key});

  final List<Friendship> sent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        const SectionHeader(title: 'Waiting on them'),
        for (final f in sent)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.container,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              spacing: Spacing.s,
              children: [
                Avatar(name: f.person.displayName, seed: f.person.id, size: 40),
                _NameBlock(person: f.person, detail: 'request sent'),
                TextLinkButton(
                  label: 'Cancel',
                  color: context.textSecondary,
                  onTap: () =>
                      context.read<FriendsCubit>().decline(f.person.id),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PeopleResults extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FriendsCubit>().state;
    final results = state.results;
    final list = results.value;
    if (results.isInProgress || results.isIdle) {
      return const ExcludeSemantics(
        child: Column(
          spacing: Spacing.xs,
          children: [
            Skeleton(height: 68, radius: 18),
            Skeleton(height: 68, radius: 18),
            Skeleton(height: 68, radius: 18),
          ],
        ),
      );
    }
    if (list == null) {
      return EmptyState(
        mood: PaprikaMood.oops,
        title: BrowseMessages.titleFor(results.error),
        body: results.error ?? '',
      );
    }
    if (list.isEmpty) {
      return const EmptyState(
        mood: PaprikaMood.thinking,
        title: 'No one by that name',
        body: 'Search by name or @username, or invite them.',
      );
    }
    return Column(
      spacing: Spacing.xs,
      children: [
        for (final cook in list)
          _ResultRow(
            person: Person(
              id: cook.id,
              username: cook.username,
              displayName: cook.displayName,
              avatarPath: cook.avatarPath,
            ),
            link: state.linkTo(cook.id),
            busy: state.busy.contains(cook.id),
          ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const new({required this.person, required this.link, required this.busy});

  final Person person;
  final FriendLink link;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FriendsCubit>();
    final (label, action) = switch (link) {
      FriendLink.friends => ('Friends', null),
      FriendLink.outgoing => ('Requested', null),
      FriendLink.incoming => ('Accept', () => cubit.accept(person.id)),
      FriendLink.none => ('Add', () => cubit.request(person.id)),
    };
    return Pressable(
      isButton: false,
      onTap: () => unawaited(context.openPerson(person.id)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          spacing: Spacing.s,
          children: [
            Avatar(name: person.displayName, seed: person.id),
            _NameBlock(person: person),
            Pressable(
              onTap: busy || action == null ? null : action,
              semanticLabel: '$label ${person.displayName}',
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: action == null ? context.container : context.sp.blush,
                  borderRadius: BorderRadius.circular(Rounding.chip),
                  border: action == null
                      ? Border.all(color: context.sp.fieldBorder, width: 1.5)
                      : null,
                ),
                child: Center(
                  widthFactor: 1,
                  child: AppText(
                    text: busy ? '…' : label,
                    config: FontConfigs.body3,
                    weight: FontWeight.w700,
                    color: action == null
                        ? context.textSecondary
                        : context.primaryDeep,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
