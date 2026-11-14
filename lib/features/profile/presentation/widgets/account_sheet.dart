import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';

class AccountSheet extends StatelessWidget {
  const new({required this.profile, required this.session, super.key});

  final Profile? profile;
  final SessionCubit session;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.xs,
      children: [
        AppText(text: p?.displayName ?? 'You', config: FontConfigs.h2),
        if (p != null)
          AppText.secondary(text: '@${p.username}', config: FontConfigs.body2),
        const SizedBox(height: Spacing.m),
        SecondaryButton(
          label: 'Sign out',
          outlined: true,
          onTap: () {
            Navigator.of(context).pop();
            unawaited(session.signOut());
          },
        ),
      ],
    );
  }
}
