import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/recipe/presentation/recipe_share.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/save_button.dart';

class RecipeHero extends StatelessWidget {
  const RecipeHero({
    required this.card,
    required this.coverUrl,
    super.key,
    this.height = 320,
  });

  final RecipeCard card;
  final String? coverUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RecipeCover(
            style: card.coverStyle,
            imageUrl: coverUrl ?? card.coverUrl,
            localPath: card.localCoverPath,
            radius: 0,
            semanticLabel: card.title,
          ),
          Positioned(
            top: top + Spacing.s,
            left: Spacing.m,
            right: Spacing.m,
            child: Row(
              spacing: Spacing.xs,
              children: [
                CircleIconButton(
                  icon: SpIcons.chevronLeft,
                  semanticLabel: 'Back',
                  onTap: () => context.pop(),
                ),
                const Spacer(),
                CircleIconButton(
                  icon: SpIcons.share,
                  semanticLabel: 'Share recipe',
                  onTap: () => unawaited(
                    context.bottomSheet<void>(_ShareSheet(card: card)),
                  ),
                ),
                SaveButton(card: card, style: SaveButtonStyle.onPhoto),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareSheet extends StatelessWidget {
  const _ShareSheet({required this.card});

  final RecipeCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.xs,
      children: [
        const AppText(text: 'Share recipe', config: FontConfigs.h2),
        AppText.secondary(
          text: card.title,
          config: FontConfigs.body2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Spacing.xs),
        _ShareRow(
          icon: SpIcons.share,
          label: 'Share…',
          onTap: () {
            Navigator.of(context).pop();
            unawaited(
              SharePlus.instance.share(
                ShareParams(
                  text: RecipeShare.message(card),
                  subject: card.title,
                ),
              ),
            );
          },
        ),
        _ShareRow(
          icon: SpIcons.link,
          label: 'Copy link',
          onTap: () async {
            final messenger = Navigator.of(context);
            await Clipboard.setData(
              ClipboardData(text: RecipeShare.link(card.id)),
            );
            messenger.pop();
            if (context.mounted) context.showSnackBarMessage('Link copied');
          },
        ),
      ],
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final SpIcons icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.m),
        decoration: BoxDecoration(
          color: context.container,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          spacing: Spacing.s,
          children: [
            SpIcon(icon, color: context.primary),
            AppText(
              text: label,
              config: FontConfigs.body2,
              weight: FontWeight.w600,
            ).expand(),
            SpIcon(SpIcons.chevronRight, size: 18, color: context.sp.chevron),
          ],
        ),
      ),
    );
  }
}
