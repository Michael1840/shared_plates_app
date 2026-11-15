import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({required this.text, super.key, this.raised = true});

  final String text;
  final bool raised;

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
            color: raised
                ? context.sp.shadow
                : context.sp.printShadow.withValues(alpha: 0.05),
            blurRadius: raised ? 16 : 2,
            offset: Offset(0, raised ? 6 : 1),
          ),
        ],
      ),
      child: AppText(text: text, config: FontConfigs.body2),
    );
  }
}
