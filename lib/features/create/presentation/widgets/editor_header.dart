import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/palette.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/tape.dart';
import 'package:shared_plates_app/features/create/data/photo_store.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/recipe_editor_cubit.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/editor_fields.dart';

class EditorTopBar extends StatelessWidget {
  const EditorTopBar({
    required this.onClose,
    required this.onPreview,
    super.key,
  });

  final VoidCallback onClose;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final save = context.select<RecipeEditorCubit, SaveStatus>(
      (c) => c.state.save,
    );
    final (label, icon) = switch (save) {
      SaveStatus.clean => ('Nothing to save yet', SpIcons.pencil),
      SaveStatus.pending || SaveStatus.saving => ('Saving…', SpIcons.clock),
      SaveStatus.saved => ('Draft saved', SpIcons.check),
      SaveStatus.failed => ("Couldn't save", SpIcons.ban),
    };
    return Row(
      spacing: Spacing.s,
      children: [
        CircleIconButton(
          icon: SpIcons.close,
          semanticLabel: 'Close editor',
          onTap: onClose,
        ),
        Semantics(
          liveRegion: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: Spacing.xs,
            children: [
              SpIcon(icon, size: 16, color: context.textSecondary),
              AppText.secondary(text: label, config: FontConfigs.sublabel1),
            ],
          ),
        ).expand(),
        Pressable(
          onTap: onPreview,
          child: Container(
            height: Sizes.minTap,
            padding: const EdgeInsets.symmetric(horizontal: Spacing.m),
            decoration: BoxDecoration(
              color: context.container,
              borderRadius: BorderRadius.circular(Rounding.pill),
              border: Border.all(color: context.line),
            ),
            child: const Center(
              widthFactor: 1,
              child: AppText(
                text: 'Preview',
                config: FontConfigs.body3,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReadyCard extends StatelessWidget {
  const ReadyCard({super.key});

  static String _count(int n, String word) => '$n $word${n == 1 ? '' : 's'}';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RecipeEditorCubit>().state;
    final draft = state.draft;
    final problems = draft.problems;
    final ready = problems.isEmpty;
    final n = draft.ingredients.length;
    final s = draft.filledSteps.length;
    final named = !problems.contains(DraftProblem.name);
    final photo = draft.localCoverPath != null || draft.coverPath != null;
    final chips = <(String, bool?)>[
      (named ? '✓ Name' : 'Name', named),
      (n > 0 ? '✓ ${_count(n, 'ingredient')}' : 'Ingredients', n > 0),
      (s > 0 ? '✓ ${_count(s, 'step')}' : 'Steps', s > 0),
      (photo ? '✓ Photo' : 'Photo: optional', null),
    ];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(84, 14, 14, 14),
          decoration: BoxDecoration(
            color: context.sp.honeySoft,
            borderRadius: BorderRadius.circular(Rounding.print),
            boxShadow: [
              BoxShadow(
                color: context.sp.printShadow.withValues(alpha: 0.1),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.xs,
            children: [
              HandwrittenNote(
                ready ? 'Ready to share!' : 'Nearly there',
                large: true,
              ),
              Wrap(
                spacing: Spacing.xs,
                runSpacing: 6,
                children: [
                  for (final (label, ok) in chips)
                    _ReadyChip(
                      label: label,
                      ok: ok,
                      flagged: state.showProblems && ok == false,
                    ),
                ],
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
        Positioned(
          left: 4,
          top: 0,
          bottom: 0,
          child: Center(
            child: Paprika(
              mood: ready ? PaprikaMood.cheer : PaprikaMood.thinking,
              size: 76,
              decorative: true,
            ),
          ),
        ),
      ],
    ).rotated(-0.8);
  }
}

class _ReadyChip extends StatelessWidget {
  const _ReadyChip({
    required this.label,
    required this.ok,
    required this.flagged,
  });

  final String label;
  final bool? ok;
  final bool flagged;

  @override
  Widget build(BuildContext context) {
    final (fill, ink) = switch ((ok, flagged)) {
      (true, _) => (Palette.sage, Palette.sageInk),
      (_, true) => (context.sp.blush, context.primaryDeep),
      _ => (context.sp.progressTrack, context.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(Rounding.pill),
      ),
      child: AppText(
        text: label,
        config: FontConfigs.sublabel2,
        weight: FontWeight.w600,
        color: ink,
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final draft = context.select<RecipeEditorCubit, RecipeDraft>(
      (c) => c.state.draft,
    );
    final cubit = context.read<RecipeEditorCubit>();
    final local = draft.localCoverPath;
    return DashedBox(
      color: context.sp.handle,
      fill: Palette.draftPaper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s,
        children: [
          if (local != null) ...[
            RecipeCover(
              style: draft.coverStyle,
              localPath: local,
              height: 180,
              radius: Rounding.row,
              semanticLabel: 'Your photo',
            ),
            Row(
              spacing: Spacing.xs,
              children: [
                SecondaryButton(
                  label: 'Change photo',
                  icon: SpIcons.camera,
                  height: Sizes.minTap,
                  outlined: true,
                  onTap: () => unawaited(_choose(context, cubit)),
                ).expand(),
                SecondaryButton(
                  label: 'Remove',
                  height: Sizes.minTap,
                  outlined: true,
                  onTap: cubit.removePhoto,
                ).expand(),
              ],
            ),
          ] else ...[
            SecondaryButton(
              label: 'Add a photo (optional)',
              icon: SpIcons.camera,
              dark: true,
              onTap: () => unawaited(_choose(context, cubit)),
            ),
            const AppText.secondary(
              text: "No photo? We'll use a cover that matches your tags:",
              config: FontConfigs.sublabel1,
            ),
            Row(
              spacing: Spacing.xs,
              children: [
                for (final style in CoverStyle.values)
                  _CoverOption(
                    style: style,
                    selected: draft.coverStyle == style,
                    onTap: () => cubit.setCoverStyle(style),
                  ).expand(),
              ],
            ),
          ],
        ],
      ).paddingAll(Spacing.m),
    );
  }

  Future<void> _choose(BuildContext context, RecipeEditorCubit cubit) async {
    final source = await context.bottomSheet<PhotoSource>(
      const _PhotoSourceSheet(),
    );
    if (source != null) await cubit.pickPhoto(source);
  }
}

class _CoverOption extends StatelessWidget {
  const _CoverOption({
    required this.style,
    required this.selected,
    required this.onTap,
  });

  static const Map<CoverStyle, String> _labels = {
    CoverStyle.stew: 'Stew cover',
    CoverStyle.meat: 'Meat cover',
    CoverStyle.veg: 'Veg cover',
    CoverStyle.sweet: 'Sweet cover',
    CoverStyle.any: 'General cover',
  };

  final CoverStyle style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: Pressable(
        onTap: onTap,
        semanticLabel: _labels[style],
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? context.primary : Colors.transparent,
                width: 3,
              ),
            ),
            child: RecipeCover(style: style, radius: 11),
          ),
        ),
      ),
    );
  }
}

class _PhotoSourceSheet extends StatelessWidget {
  const _PhotoSourceSheet();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        const Entrance(
          child: AppText(text: 'Add a photo', config: FontConfigs.h2),
        ),
        SecondaryButton(
          label: 'Take a photo',
          icon: SpIcons.camera,
          onTap: () => Navigator.of(context).pop(PhotoSource.camera),
        ),
        SecondaryButton(
          label: 'Choose from your photos',
          icon: SpIcons.recipes,
          onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
        ),
      ],
    );
  }
}

class PasteTextSheet extends StatefulWidget {
  const PasteTextSheet({
    required this.title,
    required this.hint,
    required this.action,
    super.key,
  });

  final String title;
  final String hint;
  final String action;

  @override
  State<PasteTextSheet> createState() => _PasteTextSheetState();
}

class _PasteTextSheetState extends State<PasteTextSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s,
        children: [
          AppText(text: widget.title, config: FontConfigs.h2),
          Container(
            padding: const EdgeInsets.all(Spacing.m),
            decoration: BoxDecoration(
              color: context.container,
              borderRadius: BorderRadius.circular(18),
            ),
            child: EditorTextField(
              controller: _controller,
              config: FontConfigs.body3,
              hint: widget.hint,
              autofocus: true,
              minLines: 6,
              maxLines: 12,
              keyboardType: TextInputType.multiline,
            ),
          ),
          PrimaryButton(
            label: widget.action,
            onTap: () => Navigator.of(context).pop(_controller.text),
          ),
        ],
      ),
    );
  }
}
