import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/tape.dart';

class StatusNote extends StatelessWidget {
  const StatusNote({
    required this.lead,
    required this.body,
    super.key,
    this.icon = SpIcons.ban,
  });

  factory StatusNote.offline({Key? key}) => StatusNote(
    key: key,
    lead: "You're offline.",
    body: 'Showing what loaded last time.',
  );

  final String lead;
  final String body;
  final SpIcons icon;

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.honeyInk;
    return Entrance(
      style: EntranceStyle.print,
      child: Semantics(
        liveRegion: true,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.m,
                vertical: Spacing.s,
              ),
              decoration: BoxDecoration(
                color: context.sp.honeySoft,
                borderRadius: BorderRadius.circular(Rounding.print),
                boxShadow: [
                  BoxShadow(
                    color: context.sp.printShadow.withValues(alpha: 0.1),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                spacing: Spacing.s,
                children: [
                  SpIcon(icon, color: ink),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$lead ',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: body),
                      ],
                    ),
                    style: context.textStyle(FontConfigs.body3, color: ink),
                  ).expand(),
                ],
              ),
            ),
            const Positioned(
              top: -9,
              left: 24,
              child: Tape(width: 48, height: 16, tilt: -3),
            ),
          ],
        ),
      ).rotated(-0.8),
    );
  }
}

class ErrorRetry extends StatelessWidget {
  const ErrorRetry({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText.secondary(text: message, config: FontConfigs.body3).expand(),
        TextButton(
          onPressed: onRetry,
          child: AppText(
            text: 'Retry',
            config: FontConfigs.body3,
            weight: FontWeight.w600,
            color: context.primary,
          ),
        ),
      ],
    );
  }
}
