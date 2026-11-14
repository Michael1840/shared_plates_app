import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/person_row.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/onboarding_scaffold.dart';

class OnboardingFriendsPage extends StatefulWidget {
  const new({super.key});

  @override
  State<OnboardingFriendsPage> createState() => _OnboardingFriendsPageState();
}

class _OnboardingFriendsPageState extends State<OnboardingFriendsPage> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<OnboardingCubit>().loadCooks());
  }

  Future<void> _finish() async {
    final cubit = context.read<OnboardingCubit>();
    final done = await cubit.finish();
    if (!mounted) return;
    if (done) {
      context.read<SessionCubit>().completeOnboarding();
    } else {
      final error = cubit.state.saving.error;
      if (error != null) context.showSnackBarError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    return OnboardingScaffold(
      header: OnboardingHeader(
        step: 3,
        stepLabel: 'Last step',
        message:
            "Cooking's better with company. Want to bring your people "
            'along?',
        mood: PaprikaMood.wink,
        onBack: () => context.pop(),
        onSkip: _finish,
      ),
      action: PrimaryButton(
        label: 'Start cooking',
        busyLabel: 'Saving…',
        isBusy: state.saving.isInProgress,
        onTap: _finish,
      ),
      children: [
        _InviteCard(username: state.username),
        const SizedBox(height: Spacing.l),
        Semantics(
          header: true,
          child: const AppText(
            text: 'Popular cooks for your tastes',
            config: FontConfigs.body3,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Spacing.s),
        const _CookList(),
      ],
    );
  }
}

class _InviteCard extends StatelessWidget {
  const new({required this.username});

  final String username;

  Future<void> _copy(BuildContext context) async {
    final handle = username.isEmpty ? '' : " I'm @$username.";
    await Clipboard.setData(
      ClipboardData(text: 'Come cook with me on SharedPlates.$handle'),
    );
    if (context.mounted) context.showSnackBarMessage('Invite copied');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.m),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Spacing.s,
        children: [
          const AppText(
            text: 'Invite friends',
            config: FontConfigs.body2,
            weight: FontWeight.w700,
          ),
          AppText.secondary(
            text: username.isEmpty
                ? 'They can find you once they join.'
                : 'They can find you as @$username.',
            config: FontConfigs.sublabel1,
          ),
          SecondaryButton(
            label: 'Copy invite',
            icon: SpIcons.link,
            height: 48,
            dark: true,
            onTap: () => _copy(context),
          ),
        ],
      ),
    );
  }
}

class _CookList extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final state = context.watch<OnboardingCubit>().state;
    final cooks = state.cooks;
    if (cooks.isInProgress || cooks.isIdle) {
      return const Column(
        spacing: Spacing.xs,
        children: [
          Skeleton(height: 68, radius: 18),
          Skeleton(height: 68, radius: 18),
          Skeleton(height: 68, radius: 18),
        ],
      );
    }
    final error = cooks.error;
    if (error != null) {
      return Row(
        children: [
          AppText.secondary(text: error, config: FontConfigs.body3).expand(),
          TextLinkButton(label: 'Retry', onTap: cubit.loadCooks),
        ],
      );
    }
    final list = cooks.value ?? const [];
    if (list.isEmpty) {
      return const AppText.secondary(
        text: 'No cooks to suggest yet. You could be the first!',
        config: FontConfigs.body3,
      );
    }
    return Column(
      spacing: Spacing.xs,
      children: [
        for (final (i, cook) in list.indexed)
          Entrance.staggered(
            index: i,
            child: PersonRow(
              cook: cook,
              index: i,
              requested: state.requested.contains(cook.id),
              onAdd: () => cubit.requestFriend(cook.id),
            ),
          ),
      ],
    );
  }
}
