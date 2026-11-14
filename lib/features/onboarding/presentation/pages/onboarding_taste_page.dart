import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/skeleton.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_chip.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/taste_icons.dart';
import 'package:shared_plates_app/features/profile/domain/avoid_option.dart';

class OnboardingTastePage extends StatelessWidget {
  const new({super.key});

  Future<void> _continue(BuildContext context) async {
    final cubit = context.read<OnboardingCubit>();
    final saved = await cubit.saveTastes();
    if (!context.mounted) return;
    if (saved) {
      await context.push(Routes.onboardingFriends);
    } else {
      final error = cubit.state.saving.error;
      if (error != null) context.showSnackBarError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final state = context.watch<OnboardingCubit>().state;
    final picked = state.tasteIds.length;
    return OnboardingScaffold(
      header: OnboardingHeader(
        step: 2,
        stepLabel: 'Step 2 of 3',
        message:
            "What do you love cooking? Pick a few and I'll fill your "
            'feed with them.',
        mood: PaprikaMood.thinking,
        onBack: () => context.pop(),
        onSkip: () => context.push(Routes.onboardingFriends),
      ),
      action: PrimaryButton(
        label: picked == 0 ? 'Continue' : 'Continue · $picked picked',
        busyLabel: 'Saving…',
        isBusy: state.saving.isInProgress,
        onTap: () => _continue(context),
      ),
      children: [
        const _GroupTitle(text: "I'm into…"),
        const SizedBox(height: Spacing.s),
        if (state.tags.isEmpty)
          const _ChipSkeletons()
        else
          Wrap(
            spacing: Spacing.xs,
            runSpacing: Spacing.xs,
            children: [
              for (final (i, tag) in state.tags.indexed)
                Entrance.staggered(
                  index: i,
                  child: SpChip(
                    label: tag.label,
                    icon: TasteIcons.forSlug(tag.slug),
                    height: 44,
                    selected: state.tasteIds.contains(tag.id),
                    onTap: () => cubit.toggleTaste(tag.id),
                  ),
                ),
            ],
          ),
        const SizedBox(height: Spacing.l),
        const _GroupTitle(text: 'Hide recipes with…'),
        const SizedBox(height: Spacing.xxs),
        const AppText.secondary(
          text: 'Optional. You can change this in Settings.',
          config: FontConfigs.sublabel1,
        ),
        const SizedBox(height: Spacing.s),
        Wrap(
          spacing: Spacing.xs,
          runSpacing: Spacing.xs,
          children: [
            for (final option in AvoidOption.values)
              SpChip(
                label: option.label,
                icon: SpIcons.ban,
                tone: ChipTone.neutral,
                height: 44,
                selected: state.avoid.contains(option),
                onTap: () => cubit.toggleAvoid(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: AppText(
        text: text,
        config: FontConfigs.body3,
        weight: FontWeight.w600,
      ),
    );
  }
}

class _ChipSkeletons extends StatelessWidget {
  const new();

  static const _widths = <double>[120, 96, 104, 88, 132, 92, 110, 84];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        for (final w in _widths)
          Skeleton(width: w, height: 44, radius: Rounding.chip),
      ],
    );
  }
}
