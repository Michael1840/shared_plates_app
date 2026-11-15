import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/utils/screen_awake.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/empty_state.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/cook/domain/cook_args.dart';
import 'package:shared_plates_app/features/cook/presentation/bloc/cook_mode_cubit.dart';
import 'package:shared_plates_app/features/cook/presentation/widgets/cook_controls.dart';
import 'package:shared_plates_app/features/cook/presentation/widgets/cook_step_view.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';

class CookModePage extends StatelessWidget {
  const CookModePage({required this.recipeId, super.key, this.args});

  final String recipeId;
  final CookArgs? args;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    final profile = context.read<CurrentProfileCubit>().state;
    final keepOn = profile?.keepScreenOn ?? true;
    return BlocProvider(
      create: (_) {
        final cubit = CookModeCubit(
          repository: sl<RecipeDetailRepository>(),
          recipeId: recipeId,
          screen: sl<ScreenAwake>(),
          viewerId: session.status == SessionStatus.signedIn
              ? session.userId
              : null,
          keepScreenOn: keepOn,
          servings: args?.servings,
          units: args?.units ?? profile?.units ?? UnitSystem.metric,
        );
        unawaited(cubit.start());
        return cubit;
      },
      child: Theme(
        data: AppTheme.dark,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: CookModeView(keepsScreenOn: keepOn, coverUrl: args?.coverUrl),
        ),
      ),
    );
  }
}

class CookModeView extends StatelessWidget {
  const CookModeView({required this.keepsScreenOn, super.key, this.coverUrl});

  final bool keepsScreenOn;
  final String? coverUrl;

  void _onAlarm(BuildContext context, CookModeState state) {
    unawaited(HapticFeedback.heavyImpact());
    unawaited(SystemSound.play(SystemSoundType.alert));
    final step = (state.alarmStep ?? 0) + 1;
    context.showSnackBarMessage('Step $step timer is done.');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CookModeCubit, CookModeState>(
      listenWhen: (a, b) => a.alarmTick != b.alarmTick,
      listener: _onAlarm,
      child: Scaffold(
        body: DotGridBackground(
          child: SafeArea(
            child: BlocBuilder<CookModeCubit, CookModeState>(
              buildWhen: (a, b) => a.detail != b.detail,
              builder: (context, state) {
                final error = state.detail.error;
                if (error != null) return _CookMissing(message: error);
                if (!state.detail.isSuccessful) {
                  return const Center(
                    child: Paprika(mood: PaprikaMood.focused, size: 96),
                  );
                }
                return _CookBody(
                  keepsScreenOn: keepsScreenOn,
                  coverUrl: coverUrl,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CookBody extends StatelessWidget {
  const _CookBody({required this.keepsScreenOn, required this.coverUrl});

  final bool keepsScreenOn;
  final String? coverUrl;

  void _finish(BuildContext context) {
    final state = context.read<CookModeCubit>().state;
    final card = state.detail.value?.card;
    if (card == null) return;
    context.pushReplacement(
      Routes.cookedFor(card.id),
      extra: CookedArgs(
        card: card,
        servings: state.currentServings,
        coverUrl: coverUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CookTopBar(),
        const SizedBox(height: Spacing.m),
        const StepSegments(),
        if (keepsScreenOn) const AwakeNote().paddingOnly(top: Spacing.s),
        const CookStepArea().expand(),
        const OtherTimers(),
        const AppText.secondary(
          text: 'Messy hands? Swipe, or tap either side of the screen.',
          config: FontConfigs.sublabel2,
          align: TextAlign.center,
        ).paddingOnly(top: Spacing.xs, bottom: 10),
        StepNavButtons(onFinish: () => _finish(context)),
      ],
    ).paddingOnly(
      left: Spacing.gutter,
      right: Spacing.gutter,
      top: Spacing.s,
      bottom: Spacing.m,
    );
  }
}

class _CookMissing extends StatelessWidget {
  const _CookMissing({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CircleIconButton(
            icon: SpIcons.close,
            semanticLabel: 'Leave cook mode',
            fill: context.raised,
            onTap: () => context.pop(),
          ),
        ),
        const Spacer(),
        EmptyState(
          mood: PaprikaMood.oops,
          title: "Can't start cooking",
          body: message,
        ),
        const Spacer(flex: 2),
      ],
    ).paddingAll(Spacing.gutter);
  }
}
