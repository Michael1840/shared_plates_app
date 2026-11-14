import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_text_field.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/onboarding_scaffold.dart';
import 'package:shared_plates_app/features/onboarding/presentation/widgets/unit_choice_card.dart';

class OnboardingYouPage extends StatefulWidget {
  const new({super.key});

  @override
  State<OnboardingYouPage> createState() => _OnboardingYouPageState();
}

class _OnboardingYouPageState extends State<OnboardingYouPage> {
  late final OnboardingCubit _cubit = context.read<OnboardingCubit>();
  late final TextEditingController _name = TextEditingController(
    text: _cubit.state.displayName,
  );
  late final TextEditingController _username = TextEditingController(
    text: _cubit.state.username,
  );

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final saved = await _cubit.saveYou();
    if (!mounted) return;
    if (saved) {
      await context.push(Routes.onboardingTaste);
    } else {
      final error = _cubit.state.saving.error;
      if (error != null) context.showSnackBarError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingCubit>().state;
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (a, b) => a.originalUsername != b.originalUsername,
      listener: (context, state) {
        _name.text = state.displayName;
        _username.text = state.username;
      },
      child: OnboardingScaffold(
        header: OnboardingHeader(
          step: 1,
          stepLabel: 'Step 1 of 3 · about a minute',
          message:
              "Hi, I'm Paprika! I'll be your kitchen buddy. "
              'What should I call you?',
          mood: PaprikaMood.happy,
          onBack: () => context.read<SessionCubit>().signOut(),
          onSkip: () => context.push(Routes.onboardingTaste),
        ),
        action: PrimaryButton(
          label: 'Continue',
          busyLabel: 'Saving…',
          isBusy: state.saving.isInProgress,
          onTap: state.canContinueYou ? _continue : null,
        ),
        children: [
          SpTextField(
            label: 'Your name',
            controller: _name,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            helper: 'Change it if you like.',
            onChanged: _cubit.nameChanged,
          ),
          const SizedBox(height: Spacing.m),
          SpTextField(
            label: 'Username',
            controller: _username,
            prefixText: '@',
            autocorrect: false,
            autofillHints: const [AutofillHints.username],
            status: switch (state.usernameCheck) {
              UsernameCheck.available => FieldStatus.success,
              UsernameCheck.taken || UsernameCheck.invalid => FieldStatus.error,
              _ => FieldStatus.idle,
            },
            trailing: _UsernameStatus(check: state.usernameCheck),
            helper: switch (state.usernameCheck) {
              UsernameCheck.invalid =>
                '3 to 24 letters, numbers, dots or underscores.',
              UsernameCheck.taken => 'Someone has that one. Try another.',
              UsernameCheck.offline =>
                "Can't check right now. Keep your current one for now.",
              _ => 'Friends find you with this.',
            },
            onChanged: _cubit.usernameChanged,
          ),
          const SizedBox(height: Spacing.l),
          const AppText(
            text: 'How do you measure?',
            config: FontConfigs.body3,
            weight: FontWeight.w600,
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            spacing: Spacing.s,
            children: [
              UnitChoiceCard(
                title: 'Metric',
                subtitle: 'g · ml · °C',
                icon: SpIcons.ruler,
                selected: state.units == UnitSystem.metric,
                onTap: () => _cubit.unitsChanged(UnitSystem.metric),
              ).expand(),
              UnitChoiceCard(
                title: 'Imperial',
                subtitle: 'oz · cups · °F',
                icon: SpIcons.mug,
                selected: state.units == UnitSystem.imperial,
                onTap: () => _cubit.unitsChanged(UnitSystem.imperial),
              ).expand(),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          AppText.secondary(
            text: state.unitsFromRegion
                ? 'Picked from your phone’s region. Every recipe converts '
                      'automatically.'
                : 'Every recipe converts automatically.',
            config: FontConfigs.sublabel2,
          ),
        ],
      ),
    );
  }
}

class _UsernameStatus extends StatelessWidget {
  const new({required this.check});

  final UsernameCheck check;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    return switch (check) {
      UsernameCheck.available => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          SpIcon(SpIcons.check, size: 18, color: sp.success),
          AppText(
            text: 'Available',
            config: FontConfigs.sublabel1,
            weight: FontWeight.w600,
            color: sp.success,
          ),
        ],
      ),
      UsernameCheck.checking => const AppText.secondary(
        text: 'Checking…',
        config: FontConfigs.sublabel1,
      ),
      UsernameCheck.taken => AppText(
        text: 'Taken',
        config: FontConfigs.sublabel1,
        weight: FontWeight.w600,
        color: sp.primaryDeep,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
