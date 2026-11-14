import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pop_on_change.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/recipe_action_helpers.dart';

enum SaveButtonStyle { onPhoto, onCard }

class SaveButton extends StatelessWidget {
  const new({
    required this.card,
    super.key,
    this.style = SaveButtonStyle.onCard,
    this.size = 44,
  });

  final RecipeCard card;
  final SaveButtonStyle style;
  final double size;

  @override
  Widget build(BuildContext context) {
    final saved = context.select<RecipeActionsCubit, bool>(
      (c) => c.state.isSaved(card.id),
    );
    final sp = context.sp;
    final fill = switch ((style, saved)) {
      (SaveButtonStyle.onPhoto, true) => sp.primary,
      (SaveButtonStyle.onPhoto, false) => sp.card,
      (SaveButtonStyle.onCard, true) => sp.blush,
      (SaveButtonStyle.onCard, false) => sp.background,
    };
    final ink = switch ((style, saved)) {
      (SaveButtonStyle.onPhoto, true) => sp.onPrimary,
      (SaveButtonStyle.onCard, true) => sp.primary,
      _ => sp.textPrimary,
    };
    return Pressable(
      onTap: () => unawaited(context.toggleSave(card)),
      semanticLabel: saved
          ? 'Remove ${card.title} from saved'
          : 'Save ${card.title}',
      child: AnimatedContainer(
        duration: context.motion(Motion.small),
        width: size,
        height: size,
        decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: PopOnChange(
          value: saved,
          child: SpIcon(
            SpIcons.bookmark,
            size: size * 0.42,
            color: ink,
            filled: saved,
          ),
        ),
      ),
    );
  }
}
