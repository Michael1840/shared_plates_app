import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class OnboardingHeader extends StatelessWidget {
  const new({
    required this.step,
    required this.stepLabel,
    required this.message,
    required this.mood,
    required this.onBack,
    super.key,
    this.onSkip,
  });

  static const steps = 3;

  final int step;
  final String stepLabel;
  final String message;
  final PaprikaMood mood;
  final VoidCallback onBack;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    final skip = onSkip;
    return HeaderBlock(
      radius: 36,
      bottomPadding: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: Spacing.s,
            children: [
              HeaderIconButton(
                icon: SpIcons.chevronLeft,
                semanticLabel: 'Back',
                onTap: onBack,
              ),
              Semantics(
                label: 'Step $step of $steps',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Spacing.xs,
                  children: [
                    _Progress(step: step, ink: ink),
                    AppText(
                      text: stepLabel,
                      config: FontConfigs.sublabel2,
                      color: context.sp.noteOnHeader,
                    ),
                  ],
                ),
              ).expand(),
              if (skip != null)
                TextLinkButton(label: 'Skip', color: ink, onTap: skip),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Transform.translate(
                offset: const Offset(-8, 14),
                child: Paprika(mood: mood, size: 92, decorative: true),
              ),
              Entrance(
                delay: const Duration(milliseconds: 120),
                child: _SpeechBubble(text: message),
              ).paddingOnly(bottom: 10).expand(),
            ],
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const new({required this.step, required this.ink});

  final int step;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Spacing.xs,
      children: [
        for (var i = 1; i <= OnboardingHeader.steps; i++)
          AnimatedContainer(
            duration: context.motion(Motion.medium),
            curve: Motion.arrive,
            height: 6,
            decoration: BoxDecoration(
              color: i <= step ? ink : ink.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          ).expand(),
      ],
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const new({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.m, vertical: 14),
      decoration: BoxDecoration(
        color: context.container,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
          bottomRight: Radius.circular(22),
          bottomLeft: Radius.circular(6),
        ),
        boxShadow: [
          BoxShadow(
            color: context.sp.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AppText(text: text, config: FontConfigs.body2),
    );
  }
}
