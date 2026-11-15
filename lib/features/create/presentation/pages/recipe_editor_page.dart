import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/data/photo_store.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/recipe_editor_cubit.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/create_bottom_bar.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/editor_fields.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/editor_header.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/editor_ingredients.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/editor_steps.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';

class RecipeEditorPage extends StatelessWidget {
  const RecipeEditorPage({required this.recipeId, super.key});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final uid = context.read<SessionCubit>().state.userId ?? '';
    final visibility =
        context.read<CurrentProfileCubit>().state?.defaultVisibility ??
        RecipeVisibility.friends;
    return BlocProvider(
      create: (_) {
        final cubit = RecipeEditorCubit(
          repository: sl<CreateRepository>(),
          photos: sl<PhotoStore>(),
          userId: uid,
          recipeId: recipeId,
          visibility: visibility,
        );
        unawaited(cubit.start());
        return cubit;
      },
      child: const RecipeEditorView(),
    );
  }
}

class RecipeEditorView extends StatelessWidget {
  const RecipeEditorView({super.key});

  Future<void> _preview(BuildContext context) async {
    final cubit = context.read<RecipeEditorCubit>();
    final draft = cubit.state.draft;
    if (draft.ingredients.isEmpty && draft.filledSteps.isEmpty) {
      context.showSnackBarMessage(
        'Add an ingredient or a step first, then preview it.',
      );
      return;
    }
    await cubit.flush();
    if (!context.mounted) return;
    unawaited(context.push(Routes.previewRecipe(cubit.state.draft.id)));
  }

  Future<void> _pasteList(BuildContext context) async {
    final cubit = context.read<RecipeEditorCubit>();
    final text = await context.bottomSheet<String>(
      const PasteTextSheet(
        title: 'Paste a list',
        hint: '2 tbsp oil\n1 onion, diced\nFor the sauce:\n1 can tomatoes',
        action: 'Add ingredients',
      ),
    );
    if (text != null && text.trim().isNotEmpty) cubit.addIngredients(text);
  }

  Future<void> _pasteMethod(BuildContext context) async {
    final cubit = context.read<RecipeEditorCubit>();
    final text = await context.bottomSheet<String>(
      const PasteTextSheet(
        title: 'Paste the method',
        hint: '1. Fry the onion until soft.\n2. Add the rest and simmer.',
        action: 'Add steps',
      ),
    );
    if (text != null && text.trim().isNotEmpty) cubit.pasteMethod(text);
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.select<RecipeEditorCubit, bool>(
      (c) => c.state.loading,
    );
    return Scaffold(
      bottomNavigationBar: loading ? null : const _EditorActions(),
      body: DotGridBackground(
        child: SafeArea(
          bottom: false,
          child: loading
              ? const Center(
                  child: Paprika(mood: PaprikaMood.thinking, size: 96),
                )
              : CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        Spacing.gutter,
                        Spacing.s,
                        Spacing.gutter,
                        Spacing.xl,
                      ),
                      sliver: SliverList.list(
                        children: [
                          EditorTopBar(
                            onClose: () => context.pop(),
                            onPreview: () => unawaited(_preview(context)),
                          ),
                          const SizedBox(height: Spacing.l),
                          const ReadyCard(),
                          const SizedBox(height: Spacing.m),
                          const PhotoCard(),
                          const SizedBox(height: Spacing.gutter),
                          const TitleField(),
                          const SizedBox(height: Spacing.m),
                          const ServesAndTime(),
                          const SizedBox(height: 28),
                          const EditorSectionTitle(title: 'Tags'),
                          const SizedBox(height: 10),
                          const TagsSection(),
                          const SizedBox(height: Spacing.l),
                          EditorSectionTitle(
                            title: 'Ingredients',
                            action: 'Paste a list',
                            onAction: () => unawaited(_pasteList(context)),
                          ),
                          const AppText.secondary(
                            text:
                                "One per line, the way you'd normally write "
                                'it. Amounts show in metric; friends who use '
                                'imperial see cups and ounces.',
                            config: FontConfigs.sublabel1,
                          ),
                          const SizedBox(height: Spacing.s),
                          const IngredientsCard(),
                          const SizedBox(height: Spacing.s),
                          const TotalsCard(),
                          AppText.secondary(
                            text:
                                'Costs are optional. Leave a price blank and '
                                "it's just left out of the total.",
                            config: FontConfigs.sublabel2,
                            color: context.textMuted,
                          ).paddingOnly(top: Spacing.xs),
                          const SizedBox(height: Spacing.l),
                          EditorSectionTitle(
                            title: 'Method',
                            action: 'Paste the method',
                            onAction: () => unawaited(_pasteMethod(context)),
                          ),
                          const AppText.secondary(
                            text:
                                'Press return for a new step. Times you '
                                'mention become timers in cook mode.',
                            config: FontConfigs.sublabel1,
                          ),
                          const SizedBox(height: Spacing.s),
                          const StepsList(),
                          const SizedBox(height: 28),
                          const EditorSectionTitle(title: 'Who can see it?'),
                          const SizedBox(height: 10),
                          const VisibilityPicker(),
                          AppText.secondary(
                            text:
                                'You can make it public later. Likes and '
                                'saves still count.',
                            config: FontConfigs.sublabel2,
                            color: context.textMuted,
                          ).paddingOnly(top: Spacing.xs),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _EditorActions extends StatelessWidget {
  const _EditorActions();

  Future<void> _publish(BuildContext context) async {
    final cubit = context.read<RecipeEditorCubit>();
    final wasPublished = cubit.state.draft.isPublished;
    final id = await cubit.publish();
    if (!context.mounted) return;
    if (id == null) {
      final error = cubit.state.publish.error;
      if (error != null) context.showSnackBarError(error);
      return;
    }
    if (wasPublished) {
      context
        ..showSnackBarMessage('Saved. Your changes are on their way.')
        ..pop();
      return;
    }
    context.pushReplacement(Routes.recipeShared(id));
  }

  Future<void> _saveDraft(BuildContext context) async {
    await context.read<RecipeEditorCubit>().saveDraft();
    if (!context.mounted) return;
    context
      ..showSnackBarMessage('Draft saved. Pick it up any time.')
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    final (visibility, published, busy) = context
        .select<RecipeEditorCubit, (RecipeVisibility, bool, bool)>(
          (c) => (
            c.state.draft.visibility,
            c.state.draft.isPublished,
            c.state.publish.isInProgress,
          ),
        );
    final label = published
        ? 'Save changes'
        : switch (visibility) {
            RecipeVisibility.public => 'Share with everyone',
            RecipeVisibility.friends => 'Share with friends',
            RecipeVisibility.private => 'Save recipe',
          };
    return CreateBottomBar(
      child: Row(
        spacing: Spacing.s,
        children: [
          if (!published)
            SizedBox(
              width: 124,
              child: SecondaryButton(
                label: 'Save draft',
                height: Sizes.button,
                outlined: true,
                onTap: () => unawaited(_saveDraft(context)),
              ),
            ),
          PrimaryButton(
            label: label,
            busyLabel: 'Saving…',
            isBusy: busy,
            onTap: () => unawaited(_publish(context)),
          ).expand(),
        ],
      ),
    );
  }
}
