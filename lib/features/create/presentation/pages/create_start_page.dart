import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/ids.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/speech_bubble.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/create_start_cubit.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/create_start_widgets.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';

class CreateStartPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final uid = session.userId;
    if (session.status != SessionStatus.signedIn || uid == null) {
      return const _GuestCreate();
    }
    return BlocProvider(
      create: (_) => CreateStartCubit(
        repository: sl<CreateRepository>(),
        recipes: sl<RecipeDetailRepository>(),
        userId: uid,
      )..start(),
      child: const CreateStartView(),
    );
  }
}

class CreateStartView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final drafts = context.select<CreateStartCubit, List<DraftSummary>>(
      (c) => c.state.drafts,
    );
    return Scaffold(
      body: DotGridBackground(
        child: CustomScrollView(
          slivers: [
            const _StartHeader().toSliver(),
            Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: Spacing.s,
                  children: [
                    StartOption(
                      icon: SpIcons.pencil,
                      title: 'Type it out',
                      body:
                          "Write how you'd text it to a friend. I'll sort out "
                          'the amounts.',
                      fill: context.primary,
                      ink: context.onPrimary,
                      highlighted: true,
                      onTap: () => context.push(Routes.editRecipe(Ids.next())),
                    ),
                    StartOption(
                      icon: SpIcons.clipboard,
                      title: 'Paste it in',
                      body:
                          'From WhatsApp, your notes or a website. '
                          "I'll split it into ingredients and steps.",
                      fill: Palette.avatars[1].$1,
                      ink: Palette.avatars[1].$2,
                      onTap: () => context.push(Routes.pasteRecipe()),
                    ),
                    StartOption(
                      icon: SpIcons.bookmark,
                      title: 'Start from a saved recipe',
                      body:
                          "Copy one you've tweaked and make it yours. "
                          'We credit the original.',
                      fill: Palette.avatars[2].$1,
                      ink: Palette.avatars[2].$2,
                      onTap: () => unawaited(_pickSaved(context)),
                    ),
                  ],
                )
                .paddingOnly(
                  left: Spacing.gutter,
                  right: Spacing.gutter,
                  top: 28,
                )
                .toSliver(),
            if (drafts.isNotEmpty) ...[
              const Entrance(
                    delay: Duration(milliseconds: 160),
                    child: AppText(
                      text: 'Pick up where you left off',
                      config: FontConfigs.brand,
                    ),
                  )
                  .paddingOnly(
                    left: Spacing.gutter,
                    right: Spacing.gutter,
                    top: 28,
                    bottom: Spacing.s,
                  )
                  .toSliver(),
              SliverList.separated(
                itemCount: drafts.length,
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.xs),
                itemBuilder: (context, i) => DraftRow(
                  summary: drafts[i],
                  onTap: () =>
                      context.push(Routes.editRecipe(drafts[i].card.id)),
                  onDelete: () => unawaited(
                    context.read<CreateStartCubit>().discard(drafts[i].card.id),
                  ),
                ).paddingSymmetric(horizontal: Spacing.gutter),
              ),
            ],
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _OfflineNote(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickSaved(BuildContext context) async {
    final cubit = context.read<CreateStartCubit>();
    unawaited(cubit.loadSaved());
    final id = await context.bottomSheet<String>(
      BlocProvider.value(value: cubit, child: const SavedPickerSheet()),
    );
    if (id == null || !context.mounted) return;
    final forked = await cubit.startFrom(id);
    if (!context.mounted) return;
    if (forked == null) {
      final error = cubit.state.fork.error;
      if (error != null) context.showSnackBarError(error);
      return;
    }
    unawaited(context.push(Routes.editRecipe(forked)));
  }
}

class _StartHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    return HeaderBlock(
      radius: 36,
      bottomPadding: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: HeaderIconButton(
              icon: SpIcons.close,
              semanticLabel: 'Close',
              onTap: () =>
                  context.canPop() ? context.pop() : context.go(Routes.home),
            ),
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
                    text: 'New recipe',
                    config: FontConfigs.title,
                    color: ink,
                  ),
                ),
              ),
              const HandwrittenNote(
                'ooh, exciting',
                surface: NoteSurface.header,
                tilt: -3,
              ).paddingOnly(bottom: 4),
            ],
          ).paddingOnly(top: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Transform.translate(
                offset: const Offset(-8, 14),
                child: const Paprika(size: 92, decorative: true),
              ),
              const Entrance(
                delay: Duration(milliseconds: 120),
                child: SpeechBubble(
                  text:
                      "Start however's easiest. You can change anything "
                      "later, and I'll save as you go.",
                ),
              ).paddingOnly(bottom: 10).expand(),
            ],
          ).paddingOnly(top: 14),
        ],
      ),
    );
  }
}

class _OfflineNote extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.xs,
      children: [
        SpIcon(SpIcons.phone, size: 16, color: context.textMuted),
        AppText.secondary(
          text: 'Drafts save on your phone, even offline.',
          config: FontConfigs.sublabel1,
          color: context.textMuted,
        ),
      ],
    ).paddingOnly(
      top: Spacing.l,
      bottom: MediaQuery.paddingOf(context).bottom + Spacing.l,
    );
  }
}

class _GuestCreate extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CircleIconButton(
                  icon: SpIcons.close,
                  semanticLabel: 'Close',
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go(Routes.home),
                ),
              ),
              const Spacer(),
              EmptyState(
                mood: PaprikaMood.wink,
                title: 'Share your recipes',
                body:
                    'Make an account to write recipes, keep drafts and share '
                    'them with friends.',
                actions: [
                  CompactButton(
                    label: 'Sign in',
                    onTap: () =>
                        unawaited(context.read<SessionCubit>().leaveGuest()),
                  ),
                ],
              ),
              const Spacer(flex: 2),
            ],
          ).paddingAll(Spacing.gutter),
        ),
      ),
    );
  }
}
