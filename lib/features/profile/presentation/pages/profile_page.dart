import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
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
import 'package:shared_plates_app/core/widgets/section_header.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/tape.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/friends/data/friends_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/profile_page_cubit.dart';
import 'package:shared_plates_app/features/profile/presentation/widgets/edit_profile_sheet.dart';
import 'package:shared_plates_app/features/recipes/data/library_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<SessionCubit>().state.userId ?? '';
    return BlocProvider(
      create: (_) {
        final cubit = ProfilePageCubit(
          library: sl<LibraryRepository>(),
          friends: sl<FriendsRepository>(),
          userId: uid,
        );
        unawaited(cubit.start());
        return cubit;
      },
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<CurrentProfileCubit>().state;
    final state = context.watch<ProfilePageCubit>().state;
    return Scaffold(
      body: DotGridBackground(
        child: CustomScrollView(
          slivers: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(profile: profile),
                Transform.translate(
                  offset: const Offset(0, -32),
                  child: _Stats(state: state)
                      .paddingSymmetric(horizontal: Spacing.gutter),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (profile != null) _ProfileActions(profile: profile),
                    const SizedBox(height: Spacing.l),
                    _Cheer(state: state),
                    const SizedBox(height: Spacing.l),
                    _YourRecipes(state: state),
                  ],
                ).paddingOnly(
                  left: Spacing.gutter,
                  right: Spacing.gutter,
                  bottom: MediaQuery.paddingOf(context).bottom + Spacing.l,
                ),
              ],
            ).toSliver(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final ink = context.sp.onHeader;
    final city = p?.city;
    final bio = p?.bio;
    return HeaderBlock(
      bottomPadding: 56,
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
                semanticLabel: 'Settings',
                onTap: () => context.push(Routes.settings),
              ),
            ],
          ),
          Row(
            spacing: Spacing.m,
            children: [
              Avatar(
                name: p?.displayName ?? '',
                seed: p?.id,
                size: 84,
                fill: ink,
                ink: context.sp.header,
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
                        text: p?.displayName ?? 'You',
                        config: FontConfigs.h1,
                        color: ink,
                      ),
                    ),
                  ),
                  if (p != null)
                    AppText(
                      text: [
                        '@${p.username}',
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
}

class _Stats extends StatelessWidget {
  const _Stats({required this.state});

  final ProfilePageState state;

  @override
  Widget build(BuildContext context) {
    final friends = state.friendCount;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.m),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(Rounding.card),
        boxShadow: [
          BoxShadow(
            color: context.sp.printShadow.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _Stat(
            value: '${state.recipes.length}',
            label: 'Recipes',
            onTap: () => context.go(Routes.recipes),
          ).expand(),
          _Stat(
            value: Formatters.compact(state.savesByOthers),
            label: 'Saves by others',
          ).expand(),
          _Stat(
            value: friends == null ? '–' : '$friends',
            label: 'Friends',
            onTap: () => context.go(Routes.friends),
          ).expand(),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.onTap});

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      spacing: 2,
      children: [
        AppText(text: value, config: FontConfigs.h2),
        AppText.secondary(
          text: label,
          config: FontConfigs.sublabel2,
          align: TextAlign.center,
        ),
      ],
    );
    final tap = onTap;
    if (tap == null) {
      return Semantics(
        label: '$value $label',
        excludeSemantics: true,
        child: content,
      );
    }
    return Pressable(
      onTap: tap,
      semanticLabel: '$value $label',
      child: content,
    );
  }
}

class _ProfileActions extends StatelessWidget {
  const _ProfileActions({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.s,
      children: [
        SecondaryButton(
          label: 'Edit profile',
          icon: SpIcons.pencil,
          height: 48,
          outlined: true,
          onTap: () => unawaited(
            context.bottomSheet<void>(EditProfileSheet(profile: profile)),
          ),
        ).expand(),
        SecondaryButton(
          label: 'Share profile',
          icon: SpIcons.share,
          height: 48,
          outlined: true,
          onTap: () => unawaited(
            SharePlus.instance.share(
              ShareParams(
                text:
                    'Cook with me on SharedPlates: @${profile.username} '
                    '${Env.shareBaseUrl}/u/${profile.username}',
              ),
            ),
          ),
        ).expand(),
      ],
    );
  }
}

class _Cheer extends StatelessWidget {
  const _Cheer({required this.state});

  final ProfilePageState state;

  @override
  Widget build(BuildContext context) {
    final saves = state.savesByOthers;
    final cooks = state.cooksByOthers;
    final busy = saves > 0 || cooks > 0;
    final body = busy
        ? [
            if (saves > 0) '${Formatters.compact(saves)} saves',
            if (cooks > 0)
              '$cooks ${cooks == 1 ? 'person' : 'people'} cooked your food',
          ].join(' and ')
        : 'Share a recipe and this is where the love shows up.';
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(84, 14, 14, 14),
          decoration: BoxDecoration(
            color: context.sp.honeySoft,
            borderRadius: BorderRadius.circular(Rounding.print),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              HandwrittenNote(
                busy ? 'Look at you go!' : 'Your kitchen awaits',
                large: true,
              ),
              AppText(
                text: busy ? '$body so far.' : body,
                config: FontConfigs.body3,
                color: context.sp.honeyInk,
              ),
            ],
          ),
        ),
        const Positioned(
          top: -10,
          left: 0,
          right: 0,
          child: Center(child: Tape(width: 64, height: 20)),
        ),
        const Positioned(
          left: 4,
          top: 0,
          bottom: 0,
          child: Center(
            child: Paprika(mood: PaprikaMood.proud, size: 76, decorative: true),
          ),
        ),
      ],
    ).rotated(-0.8);
  }
}

class _YourRecipes extends StatelessWidget {
  const _YourRecipes({required this.state});

  final ProfilePageState state;

  @override
  Widget build(BuildContext context) {
    final recipes = state.recipes;
    if (state.loaded && recipes.isEmpty) {
      return EmptyState(
        mood: PaprikaMood.happy,
        title: 'No recipes shared yet',
        body: 'Your shared recipes show here for friends to find.',
        actions: [
          CompactButton(
            label: 'Write a recipe',
            onTap: () => context.push(Routes.create),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        Row(
          children: [
            const SectionHeader(title: 'Your recipes').expand(),
            if (recipes.length > 4)
              TextLinkButton(
                label: 'See all ${recipes.length}',
                color: context.primaryDeep,
                onTap: () => context.go(Routes.recipes),
              ),
          ],
        ),
        PrintGrid(
          children: [
            for (final (i, r) in recipes.take(4).indexed)
              GridPrint(
                title: r.title,
                coverStyle: r.coverStyle,
                imageUrl: r.coverUrl,
                localPath: r.localCoverPath,
                index: i,
                meta: 'Saved ${r.saveCount}× · cooked ${r.cookCount}×',
                onTap: () => unawaited(context.openRecipe(r)),
              ),
          ],
        ),
      ],
    );
  }
}
