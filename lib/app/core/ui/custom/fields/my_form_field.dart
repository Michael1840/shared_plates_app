import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../../../utils/sizing.dart';

class MyFormField extends StatelessWidget {
  final String hint;
  final int? maxLines;
  final int? minLines;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final IconData? icon;
  final Widget? leadingWidget;
  final Widget? trailingIcon;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool obscureText;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmit;
  final double? fontSize;
  final EdgeInsets? customPadding;
  final TextStyle? hintStyle;
  final FontWeight fontWeight;
  final Color? fillColor;
  final Color? textColor;
  final TextInputAction? textAction;
  final String title;
  final bool isDate;
  final bool isRequired;
  final bool hasLabel;
  final double radius;
  const MyFormField({
    super.key,
    required this.hint,
    required this.title,
    this.onSaved,
    this.validator,
    this.fontWeight = Weights.medium,
    this.minLines,
    this.maxLines,
    this.icon,
    this.controller,
    this.focusNode,
    this.trailingIcon,
    this.onChanged,
    this.obscureText = false,
    this.maxLength,
    this.keyboardType,
    this.onSubmit,
    this.fontSize = 14,
    this.customPadding,
    this.hintStyle,
    this.fillColor,
    this.textColor,
    this.textAction,
    this.isDate = false,
    this.isRequired = false,
    this.leadingWidget,
    this.hasLabel = true,
    this.radius = Rounding.reg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        // AppText.primary(text: title),
        TextFormField(
          maxLines: maxLines ?? 1,
          controller: controller,
          focusNode: focusNode,
          style: context.myTextStyle(
            color: textColor ?? context.textPrimary,
            size: fontSize,
            weight: Weights.reg,
            decoration: TextDecoration.none,
          ),
          obscureText: obscureText,
          cursorColor: textColor ?? context.textPrimary,
          keyboardType: keyboardType,
          textInputAction: textAction,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: hasLabel ? title : null,
            hintText: hint,
            labelStyle: context.myTextStyle(
              color: textColor ?? context.textSecondary,
              size: fontSize,
              weight: Weights.reg,
              decoration: TextDecoration.none,
            ),
            hintStyle:
                hintStyle ??
                context.myTextStyle(
                  color:
                      textColor ?? context.textSecondary.withValues(alpha: 0.4),
                  size: fontSize,
                  weight: Weights.reg,
                  decoration: TextDecoration.none,
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: context.green),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: StatusColors.failure),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: StatusColors.failure),
            ),
            filled: true,
            fillColor: fillColor ?? context.container,
            contentPadding: customPadding ?? const EdgeInsets.all(16),
            prefixIconConstraints: const BoxConstraints(
              maxHeight: double.infinity,
              minWidth: 50,
            ),
            prefixIconColor: textColor ?? context.textPrimary,
            prefixIcon: icon != null
                ? Icon(icon, size: 18, color: context.textSecondary)
                : null,
            suffixIcon: trailingIcon,
            counterText: '',
          ),
          onFieldSubmitted: onSubmit,
          textAlignVertical: TextAlignVertical.top,
          minLines: minLines,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          maxLength: maxLength,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: isRequired
              ? (s) {
                  if (s == null || s.isEmpty) {
                    return 'This field is required.';
                  } else {
                    return null;
                  }
                }
              : validator,
        ),
      ],
    );
  }
}
