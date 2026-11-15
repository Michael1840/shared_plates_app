import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/app/router/navigation.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/widgets/recipe_print_card.dart';
import 'package:shared_plates_app/features/browse/presentation/card_text.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/widgets/recipe_action_helpers.dart';

class CardPrint extends StatelessWidget {
  const CardPrint({
    required this.card,
    required this.index,
    super.key,
    this.width = 224,
    this.photoHeight = 160,
    this.showStats = true,
  });

  final RecipeCard card;
  final int index;
  final double width;
  final double photoHeight;
  final bool showStats;

  @override
  Widget build(BuildContext context) {
    final saved = context.select<RecipeActionsCubit, bool>(
      (c) => c.state.isSaved(card.id),
    );
    final note = card.note;
    return RecipePrintCard(
      title: card.title,
      coverStyle: card.coverStyle,
      imageUrl: card.coverUrl,
      localPath: card.localCoverPath,
      note: note == null || note.length > 40 ? null : note,
      minutes: showStats ? card.totalMinutes : null,
      likes: showStats ? card.likeCount : null,
      priceLabel: showStats ? card.plateLabel : null,
      isSaved: saved,
      tilt: index.isEven ? -1.8 : 1.6,
      tapeTilt: index.isEven ? 3 : -4,
      width: width,
      photoHeight: photoHeight,
      delay: Duration(milliseconds: 160 + 70 * (index.clamp(0, 5))),
      onTap: () => unawaited(context.openRecipe(card)),
      onSave: () => unawaited(context.toggleSave(card)),
    );
  }
}
