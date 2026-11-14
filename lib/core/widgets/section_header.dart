import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';

class SectionHeader extends StatelessWidget {
  const new({
    required this.title,
    super.key,
    this.actionLabel,
    this.onAction,
    this.note,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;
    final aside = note;
    final heading = Semantics(
      header: true,
      child: AppText(text: title, config: FontConfigs.h2),
    );
    return Row(
      children: [
        if (aside == null) Expanded(child: heading) else heading,
        if (aside != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: Spacing.xs),
              child: HandwrittenNote(aside),
            ),
          ),
        if (label != null) TextLinkButton(label: label, onTap: onAction),
      ],
    );
  }
}
