import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/formatters.dart';
import 'package:shared_plates_app/core/widgets/avatar.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/grid_print.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/friends/domain/person.dart';
import 'package:shared_plates_app/features/friends/presentation/bloc/person_cubit.dart';

class PersonPage extends StatelessWidget {
  const new({required this.personId, super.key});

  final String personId;

  @override
  Widget build(BuildContext context) {
    final uid = context.read<SessionCubit>().state.userId ?? '';
    return BlocProvider(
      create: (_) {
        final cubit = PersonCubit(
          friends: sl<FriendsRepository>(),
          userId: uid,
          personId: personId,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const PersonView(),
    );
  }
}

class PersonView extends StatelessWidget {
  const new({super.key});

  static String messageFor(PersonAction action, Person person) =>
      switch (action) {
        PersonAction.added => 'Request sent to ${person.firstName}.',
        PersonAction.accepted => 'You and ${person.firstName} are friends.',
        PersonAction.removed => 'Removed ${person.firstName}.',
        PersonAction.blocked => 'Blocked ${person.firstName}.',
        PersonAction.reported => 'Thanks. We will take a look.',
      };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PersonCubit>().state;
    final profile = state.profile.value;
    return MultiBlocListener(
      listeners: [
        BlocListener<PersonCubit, PersonState>(
          listenWhen: (a, b) => a.errorTick != b.errorTick,
          listener: (context, s) {
            final error = s.error;
            if (error != null) context.showSnackBarError(error);
          },
        ),
        BlocListener<PersonCubit, PersonState>(
          listenWhen: (a, b) => a.doneTick != b.doneTick,
          listener: (context, s) {
            final done = s.done;
            final p = s.profile.value;
            if (done == null || p == null) return;
            context.showSnackBarMessage(messageFor(done, p.person));
            if (done == PersonAction.blocked) context.pop();
          },
        ),
      ],
      child: Scaffold(
        body: DotGridBackground(
          child: profile == null
              ? _PersonPlaceholder(error: state.profile.error)
              : CustomScrollView(
                  slivers: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _PersonHeader(profile: profile),
                        Transform.translate(
                          offset: const Offset(0, -32),
                          child: _Relationship(profile: profile)
                              .paddingSymmetric(horizontal: Spacing.gutter),
                        ),
                        _PersonRecipes(profile: profile).paddingOnly(
                          left: Spacing.gutter,
                          right: Spacing.gutter,
                          bottom:
                              MediaQuery.paddingOf(context).bottom + Spacing.l,
                        ),
                      ],
                    ).toSliver(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _PersonHeader extends StatelessWidget {
  const new({required this.profile});

  final PersonProfile profile;

  @override
  Widget build(BuildContext context) {
    final person = profile.person;
    final ink = context.sp.onHeaderFriends;
    final city = person.city;
    final bio = person.bio;
    return HeaderBlock(
      tone: HeaderTone.herb,
      bottomPadding: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeaderIconButton(
                icon: SpIcons.chevronLeft,
                semanticLabel: 'Back',
                tone: HeaderTone.herb,
                onTap: () => context.pop(),
              ),
              const Spacer(),
              HeaderIconButton(
                icon: SpIcons.more,
                semanticLabel: 'More: remove friend, report, block',
                tone: HeaderTone.herb,
                onTap: () => unawaited(_more(context, profile)),
              ),
            ],
          ),
          Row(
            spacing: Spacing.m,
            children: [
              Avatar(
                name: person.displayName,
                seed: person.id,
                size: 84,
                fill: ink,
                ink: context.sp.headerFriends,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Entrance(
                    delay: const Duration(milliseconds: 60),
                    child: Semantics(
                      header: true,
                      child: AppText(
                        text: person.displayName,
                        config: FontConfigs.h1,
                        color: ink,
                      ),
                    ),
                  ),
                  AppText(
                    text: [
                      '@${person.username}',
                      if (city != null && city.isNotEmpty) city,
                    ].join(' · '),
                    config: FontConfigs.body3,
                    color: ink,
                  ),
                ],
              ).expand(),
            ],
          ).paddingOnly(top: Spacing.s),
          if (bio != null && bio.isNotEmpty)
            HandwrittenNote(
              bio,
              surface: NoteSurface.header,
              tilt: -1.5,
            ).paddingOnly(top: Spacing.s),
        ],
      ),
    );
  }

  Future<void> _more(BuildContext context, PersonProfile profile) async {
    final cubit = context.read<PersonCubit>();
    final choice = await context.bottomSheet<String>(
      _MoreSheet(
        person: profile.person,
        isFriend: profile.link == FriendLink.friends,
      ),
    );
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case 'remove':
        await cubit.remove();
      case 'block':
        await cubit.block();
      case final reason when reason.startsWith('report:'):
        await cubit.report(reason.substring(7));
    }
  }
}

class _MoreSheet extends StatelessWidget {
  const new({required this.person, required this.isFriend});

  final Person person;
  final bool isFriend;

  @override
  Widget build(BuildContext context) {
    final name = person.firstName;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        AppText(text: person.displayName, config: FontConfigs.h2),
        if (isFriend)
          SecondaryButton(
            label: 'Remove $name as a friend',
            outlined: true,
            onTap: () => Navigator.of(context).pop('remove'),
          ),
        SecondaryButton(
          label: 'Report $name',
          outlined: true,
          onTap: () =>
              Navigator.of(context).pop('report:Reported from profile'),
        ),
        SecondaryButton(
          label: 'Block $name',
          dark: true,
          onTap: () => Navigator.of(context).pop('block'),
        ),
        const AppText.secondary(
          text:
              "Blocking ends the friendship and hides each other's recipes. "
              "They aren't told.",
          config: FontConfigs.sublabel1,
        ),
      ],
    );
  }
}

class _Relationship extends StatelessWidget {
  const new({required this.profile});

  final PersonProfile profile;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonCubit>();
    final busy = context.select<PersonCubit, bool>((c) => c.state.busy);
    final person = profile.person;
    final (label, fill, ink, action) = switch (profile.link) {
      FriendLink.friends => ('Friends', Palette.sage, Palette.sageInk, null),
      FriendLink.outgoing => (
        'Request sent',
        context.container,
        context.textSecondary,
        null,
      ),
      FriendLink.incoming => (
        'Accept friend request',
        context.primary,
        context.onPrimary,
        cubit.accept,
      ),
      FriendLink.none => (
        'Add friend',
        context.primary,
        context.onPrimary,
        cubit.addFriend,
      ),
    };
    return Row(
      spacing: Spacing.s,
      children: [
        Pressable(
          onTap: busy || action == null ? null : () => unawaited(action()),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(Rounding.pill),
              boxShadow: [
                BoxShadow(
                  color: context.sp.printShadow.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: Spacing.xs,
              children: [
                if (profile.link == FriendLink.friends)
                  SpIcon(SpIcons.check, size: 18, color: ink),
                AppText(
                  text: busy ? 'One sec…' : label,
                  config: FontConfigs.button1,
                  color: ink,
                ),
              ],
            ),
          ),
        ).expand(),
        CircleIconButton(
          icon: SpIcons.share,
          semanticLabel: "Share ${person.firstName}'s profile",
          size: 48,
          onTap: () => unawaited(
            SharePlus.instance.share(
              ShareParams(
                text:
                    '${person.displayName} (@${person.username}) on '
                    'SharedPlates: ${Env.shareBaseUrl}/u/${person.username}',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PersonRecipes extends StatelessWidget {
  const new({required this.profile});

  final PersonProfile profile;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PersonCubit>().state;
    final recipes = state.recipes;
    final n = profile.recipes.length;
    final saves = profile.totalSaves;
    if (n == 0) {
      return EmptyState(
        title: profile.link == FriendLink.friends
            ? 'Nothing shared yet'
            : 'Nothing to see yet',
        body: profile.link == FriendLink.friends
            ? 'When ${profile.person.firstName} shares a recipe '
                  "it'll show here."
            : 'Add ${profile.person.firstName} as a friend to see recipes '
                  'they share with friends.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: Spacing.s,
          children: [
            AppText(
              text: '$n ${n == 1 ? 'recipe' : 'recipes'}',
              config: FontConfigs.h2,
            ),
            if (saves > 0)
              HandwrittenNote('saved ${Formatters.compact(saves)} times!')
                  .paddingOnly(bottom: 2),
          ],
        ),
        if (profile.tags.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              spacing: Spacing.xs,
              children: [
                SpChip(
                  label: 'All',
                  selected: state.tagId == null,
                  onTap: () => context.read<PersonCubit>().filterTag(null),
                ),
                for (final t in profile.tags)
                  SpChip(
                    label: t.label,
                    selected: state.tagId == t.id,
                    onTap: () => context.read<PersonCubit>().filterTag(t.id),
                  ),
              ],
            ),
          ),
        const SizedBox(height: Spacing.xs),
        PrintGrid(
          children: [
            for (final (i, r) in recipes.indexed)
              GridPrint(
                title: r.title,
                coverStyle: r.coverStyle,
                imageUrl: r.coverUrl,
                localPath: r.localCoverPath,
                index: i,
                meta: [
                  ?Formatters.perPlate(r.costPerPlate),
                  if (r.likeCount > 0)
                    '${Formatters.compact(r.likeCount)} likes',
                ].join(' · '),
                onTap: () => unawaited(context.openRecipe(r)),
              ),
          ],
        ),
      ],
    );
  }
}

class _PersonPlaceholder extends StatelessWidget {
  const new({required this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    final message = error;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CircleIconButton(
              icon: SpIcons.chevronLeft,
              semanticLabel: 'Back',
              onTap: () => context.pop(),
            ),
          ),
          if (message == null) ...[
            const SizedBox(height: Spacing.l),
            const Skeleton(height: 160, radius: Rounding.header),
            const SizedBox(height: Spacing.m),
            const Skeleton(height: 48, radius: Rounding.pill),
          ] else ...[
            const Spacer(),
            EmptyState(
              mood: PaprikaMood.oops,
              title: BrowseMessages.titleFor(message),
              body: message,
              actions: [
                CompactButton(
                  label: 'Try again',
                  onTap: () => context.read<PersonCubit>().load(),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ],
      ).paddingAll(Spacing.gutter),
    );
  }
}
