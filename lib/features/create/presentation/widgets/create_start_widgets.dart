import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/create_start_cubit.dart';

class StartOption extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.body,
    required this.fill,
    required this.ink,
    required this.onTap,
    super.key,
    this.highlighted = false,
  });

  final SpIcons icon;
  final String title;
  final String body;
  final Color fill;
  final Color ink;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: '$title. $body',
      child: Container(
        padding: const EdgeInsets.all(Spacing.m),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(22),
          border: highlighted
              ? Border.all(color: context.primary, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          spacing: Spacing.m,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(Spacing.m),
              ),
              alignment: Alignment.center,
              child: SpIcon(icon, color: ink),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                AppText(
                  text: title,
                  config: FontConfigs.body1,
                  weight: FontWeight.w700,
                ),
                AppText.secondary(text: body, config: FontConfigs.sublabel1),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}

class DraftRow extends StatelessWidget {
  const new({
    required this.summary,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final DraftSummary summary;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final card = summary.card;
    final title = card.title.trim().isEmpty ? 'Untitled recipe' : card.title;
    final toGo = summary.stepsToGo;
    final progress = (3 - toGo) / 3;
    return Dismissible(
      key: ValueKey('draft-${card.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async => true,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.l),
        decoration: BoxDecoration(
          color: context.primary,
          borderRadius: BorderRadius.circular(Rounding.row),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xs,
          children: [
            SpIcon(SpIcons.trash, color: context.onPrimary),
            AppText(
              text: 'Delete draft',
              config: FontConfigs.button2,
              color: context.onPrimary,
            ),
          ],
        ),
      ),
      child: Pressable(
        onTap: onTap,
        semanticLabel: '$title, draft. ${_status(toGo)}',
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, Spacing.m, 12),
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(Rounding.row),
          ),
          child: Row(
            spacing: Spacing.s,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: context.container,
                  borderRadius: BorderRadius.circular(Rounding.photo),
                  boxShadow: [
                    BoxShadow(
                      color: context.sp.printShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: RecipeCover(
                  style: card.coverStyle,
                  localPath: card.localCoverPath,
                  width: 54,
                  height: 54,
                  radius: 2,
                ),
              ).rotated(-3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  AppText(
                    text: title,
                    config: FontConfigs.body2,
                    weight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    spacing: Spacing.xs,
                    children: [
                      _Progress(value: progress).expand(),
                      AppText.secondary(
                        text: _status(toGo),
                        config: FontConfigs.sublabel2,
                        color: context.textMuted,
                      ),
                    ],
                  ),
                ],
              ).expand(),
              SpIcon(SpIcons.chevronRight, color: context.sp.chevron),
            ],
          ),
        ),
      ),
    );
  }

  static String _status(int toGo) => switch (toGo) {
    0 => 'Ready to share',
    1 => '1 step to go',
    _ => '$toGo steps to go',
  };
}

class _Progress extends StatelessWidget {
  const new({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        height: 6,
        color: context.sp.progressTrack,
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: context.motion(Motion.medium),
          widthFactor: value.clamp(0.05, 1),
          child: Container(color: context.honey),
        ),
      ),
    );
  }
}

class SavedPickerSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = context.select<CreateStartCubit, List<RecipeCard>?>(
      (c) => c.state.saved.value,
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s,
        children: [
          const AppText(
            text: 'Start from a saved recipe',
            config: FontConfigs.h2,
          ),
          const AppText.secondary(
            text:
                "We'll copy it into your recipes and credit the cook who "
                'wrote it.',
            config: FontConfigs.body3,
          ),
          if (saved == null)
            const Skeleton(height: 72, radius: Rounding.row)
          else if (saved.isEmpty)
            const AppText.secondary(
              text: 'Save a recipe first, then make it yours here.',
              config: FontConfigs.body2,
            ).paddingSymmetric(vertical: Spacing.l)
          else
            ListView.separated(
              shrinkWrap: true,
              itemCount: saved.length,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.xs),
              itemBuilder: (context, i) => _SavedRow(card: saved[i]),
            ).flexible(),
        ],
      ),
    );
  }
}

class _SavedRow extends StatelessWidget {
  const new({required this.card});

  final RecipeCard card;

  @override
  Widget build(BuildContext context) {
    final by = card.authorName;
    return Pressable(
      onTap: () => Navigator.of(context).pop(card.id),
      semanticLabel: 'Start from ${card.title}',
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(Rounding.row),
        ),
        child: Row(
          spacing: Spacing.s,
          children: [
            RecipeCover(
              style: card.coverStyle,
              localPath: card.localCoverPath,
              width: 52,
              height: 52,
              radius: Rounding.chip,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                AppText(
                  text: card.title,
                  config: FontConfigs.body2,
                  weight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (by != null)
                  AppText.secondary(
                    text: 'by $by',
                    config: FontConfigs.sublabel1,
                    color: context.textMuted,
                  ),
              ],
            ).expand(),
            SpIcon(SpIcons.chevronRight, color: context.sp.chevron),
          ],
        ),
      ),
    );
  }
}
