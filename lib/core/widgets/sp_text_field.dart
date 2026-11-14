import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

enum FieldStatus { idle, success, error }

class SpTextField extends StatelessWidget {
  const new({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.helper,
    this.prefixText,
    this.trailing,
    this.status = FieldStatus.idle,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.autofocus = false,
    this.autocorrect = true,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final String? prefixText;
  final Widget? trailing;
  final FieldStatus status;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool autocorrect;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final border = switch (status) {
      FieldStatus.idle => sp.fieldBorder,
      FieldStatus.success => sp.success,
      FieldStatus.error => sp.primary,
    };
    final note = helper;
    final prefix = prefixText;
    final end = trailing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.xs,
      children: [
        AppText(
          text: label,
          config: FontConfigs.body3,
          weight: FontWeight.w600,
        ),
        AnimatedContainer(
          duration: context.motion(Motion.small),
          height: 54,
          padding: const EdgeInsets.only(left: Spacing.m, right: 14),
          decoration: BoxDecoration(
            color: sp.card,
            borderRadius: BorderRadius.circular(Spacing.m),
            border: Border.all(
              color: border,
              width: status == FieldStatus.idle ? 1.5 : 2,
            ),
          ),
          child: Row(
            spacing: Spacing.xxs,
            children: [
              if (prefix != null)
                AppText(
                  text: prefix,
                  config: FontConfigs.body1,
                  color: context.textMuted,
                ),
              TextField(
                controller: controller,
                autofocus: autofocus,
                autocorrect: autocorrect,
                enableSuggestions: autocorrect,
                textCapitalization: textCapitalization,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                autofillHints: autofillHints,
                inputFormatters: inputFormatters,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                cursorColor: sp.primary,
                style: context.textStyle(
                  FontConfigs.body1,
                  color: context.textPrimary,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: context.textStyle(
                    FontConfigs.body1,
                    color: context.textMuted,
                  ),
                  semanticCounterText: '',
                ),
              ).expand(),
              ?end,
            ],
          ),
        ),
        if (note != null)
          AppText.secondary(
            text: note,
            config: FontConfigs.sublabel2,
            color: status == FieldStatus.error
                ? sp.primaryDeep
                : context.textMuted,
          ),
      ],
    );
  }
}
