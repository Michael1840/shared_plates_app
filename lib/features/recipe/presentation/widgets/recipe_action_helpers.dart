import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';

extension RecipeActionsContext on BuildContext {
  Future<void> toggleSave(RecipeCard card) async {
    final outcome = await read<RecipeActionsCubit>().toggleSave(card);
    if (outcome == ActionOutcome.needsAccount && mounted) {
      await _askToSignIn(
        'Save recipes with an account',
        'They wait for you, even offline.',
      );
    }
  }

  Future<void> toggleLike(RecipeCard card) async {
    final outcome = await read<RecipeActionsCubit>().toggleLike(card);
    if (outcome == ActionOutcome.needsAccount && mounted) {
      await _askToSignIn('Like recipes with an account', 'Cooks see the love.');
    }
  }

  Future<void> _askToSignIn(String title, String body) => bottomSheet<void>(
    _SignInPrompt(title: title, body: body, session: read<SessionCubit>()),
  );
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({
    required this.title,
    required this.body,
    required this.session,
  });

  final String title;
  final String body;
  final SessionCubit session;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.s,
      children: [
        const Paprika(mood: PaprikaMood.wink, size: 96, decorative: true),
        AppText(text: title, config: FontConfigs.h2, align: TextAlign.center),
        AppText.secondary(
          text: body,
          config: FontConfigs.body2,
          align: TextAlign.center,
        ),
        const SizedBox(height: Spacing.xs),
        PrimaryButton(
          label: 'Sign in',
          onTap: () {
            Navigator.of(context).pop();
            unawaited(session.leaveGuest());
          },
        ),
      ],
    );
  }
}
