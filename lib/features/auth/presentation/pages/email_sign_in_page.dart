import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/info_card.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_text_field.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/email_sign_in_cubit.dart';
import 'package:shared_plates_app/features/auth/presentation/widgets/code_input.dart';

class EmailSignInPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailSignInCubit(sl<AuthRepository>()),
      child: const _EmailSignInView(),
    );
  }
}

class _EmailSignInView extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final step = context.select<EmailSignInCubit, EmailStep>(
      (c) => c.state.step,
    );
    final bottom = MediaQuery.paddingOf(context).bottom;
    return PopScope(
      canPop: step == EmailStep.email,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.read<EmailSignInCubit>().changeEmail();
      },
      child: Scaffold(
        body: DotGridBackground(
          child: Column(
            children: [
              _SignInHeader(step: step),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, Spacing.l),
                child: AnimatedSwitcher(
                  duration: context.motion(Motion.medium),
                  switchInCurve: Motion.arrive,
                  switchOutCurve: Motion.leave,
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween(
                      begin: const Offset(0.15, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: step == EmailStep.email
                      ? const _EmailForm(key: ValueKey('email'))
                      : const _CodeForm(key: ValueKey('code')),
                ),
              ).expand(),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, bottom + 24),
                child: const _SignInAction(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInHeader extends StatelessWidget {
  const new({required this.step});

  final EmailStep step;

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    final email = context.select<EmailSignInCubit, String>(
      (c) => c.state.email,
    );
    final codeStep = step == EmailStep.code;
    return HeaderBlock(
      radius: 36,
      bottomPadding: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -6,
            top: 14,
            child: Column(
              children: [
                Paprika(
                  key: ValueKey(step),
                  mood: codeStep ? PaprikaMood.sleepy : PaprikaMood.happy,
                  size: 120,
                  tilt: 6,
                  decorative: true,
                ),
                HandwrittenNote(
                  codeStep ? "I'll wait here..." : 'no passwords here',
                  key: ValueKey('note-$step'),
                  surface: NoteSurface.header,
                  tilt: -4,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderIconButton(
                icon: SpIcons.chevronLeft,
                semanticLabel: 'Back',
                onTap: () => codeStep
                    ? context.read<EmailSignInCubit>().changeEmail()
                    : context.pop(),
              ),
              const SizedBox(height: 72),
              Entrance(
                key: ValueKey('title-$step'),
                delay: const Duration(milliseconds: 60),
                child: SizedBox(
                  width: 220,
                  child: AppText(
                    text: codeStep ? 'Check your email' : "What's your email?",
                    config: FontConfigs.title,
                    color: ink,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.s),
              if (codeStep)
                _SentTo(email: email)
              else
                AppText(
                  text: "We'll send you a 6-digit code.",
                  config: FontConfigs.body1,
                  color: context.sp.noteOnHeader,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentTo extends StatelessWidget {
  const new({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText(
          text: 'We sent a 6-digit code to ',
          config: FontConfigs.body1,
          color: context.sp.noteOnHeader,
        ),
        AppText(
          text: email,
          config: FontConfigs.body1,
          weight: FontWeight.w700,
          color: ink,
        ),
        TextLinkButton(
          label: 'Change',
          color: ink,
          onTap: () => context.read<EmailSignInCubit>().changeEmail(),
        ),
      ],
    );
  }
}

class _EmailForm extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmailSignInCubit>();
    final error = context.select<EmailSignInCubit, String?>(
      (c) => c.state.sending.error,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.l,
      children: [
        SpTextField(
          label: 'Email',
          hint: 'you@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          autofillHints: const [AutofillHints.email],
          autocorrect: false,
          autofocus: true,
          status: error == null ? FieldStatus.idle : FieldStatus.error,
          helper: error,
          onChanged: cubit.emailChanged,
          onSubmitted: (_) => cubit.submitEmail(),
        ),
        const InfoCard(
          icon: SpIcons.shield,
          text:
              'No password to remember. The code signs you in, or sets up '
              "your account if you're new.",
        ),
      ],
    );
  }
}

class _CodeForm extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmailSignInCubit>();
    final state = context.watch<EmailSignInCubit>().state;
    final error = state.verifying.error ?? state.sending.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppText(
          text: 'Your code',
          config: FontConfigs.body3,
          weight: FontWeight.w600,
        ),
        const SizedBox(height: Spacing.s),
        CodeInput(
          length: EmailSignInState.codeLength,
          value: state.code,
          hasError: state.verifying.isError,
          enabled: !state.verifying.isInProgress,
          onChanged: cubit.codeChanged,
        ),
        if (error != null)
          AppText(
            text: error,
            config: FontConfigs.body3,
            color: context.primaryDeep,
          ).paddingOnly(top: Spacing.s),
        const SizedBox(height: Spacing.m),
        if (state.resendIn > 0)
          AppText.secondary(
            text: "Didn't get it? You can resend in ${_clock(state.resendIn)}.",
            config: FontConfigs.body3,
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: TextLinkButton(
              label: 'Send a new code',
              onTap: state.canResend ? cubit.resend : null,
            ),
          ),
        const SizedBox(height: Spacing.l),
        const InfoCard(
          icon: SpIcons.shield,
          text:
              'No password to remember. The code signs you in, or sets up '
              "your account if you're new.",
        ),
      ],
    );
  }

  static String _clock(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
}

class _SignInAction extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmailSignInCubit>();
    final state = context.watch<EmailSignInCubit>().state;
    if (state.step == EmailStep.email) {
      return PrimaryButton(
        label: 'Send my code',
        busyLabel: 'Sending…',
        isBusy: state.sending.isInProgress,
        onTap: state.emailValid ? cubit.submitEmail : null,
      );
    }
    return PrimaryButton(
      label: state.codeComplete ? 'Sign in' : 'Enter all 6 digits',
      busyLabel: 'Checking…',
      isBusy: state.verifying.isInProgress,
      onTap: state.codeComplete ? cubit.verify : null,
    );
  }
}
