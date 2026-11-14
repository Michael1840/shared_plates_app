import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/features/browse/presentation/card_text.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/save_button.dart';

class RecipePage extends StatelessWidget {
  const new({required this.recipeId, super.key, this.card});

  final String recipeId;
  final RecipeCard? card;

  @override
  Widget build(BuildContext context) {
    final c = card;
    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(Spacing.gutter),
            children: [
              Row(
                children: [
                  CircleIconButton(
                    icon: SpIcons.chevronLeft,
                    semanticLabel: 'Back',
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  if (c != null)
                    SaveButton(card: c, style: SaveButtonStyle.onPhoto),
                ],
              ),
              const SizedBox(height: Spacing.l),
              PhotoPrint(
                tapeTilt: 3,
                child: RecipeCover(
                  style: c?.coverStyle ?? CoverStyle.any,
                  imageUrl: c?.coverUrl,
                  height: 220,
                ),
              ),
              const SizedBox(height: Spacing.l),
              AppText(text: c?.title ?? 'Recipe', config: FontConfigs.h1),
              if (c != null)
                AppText.secondary(text: c.byline, config: FontConfigs.body2),
              const SizedBox(height: Spacing.l),
              const StickyNote(
                body: 'The full recipe page lands in the next build.',
                mood: PaprikaMood.focused,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
