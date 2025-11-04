import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../containers/default_container.dart';

class CustomDropdownValue {
  final int id;
  final String value;

  const CustomDropdownValue({required this.id, required this.value});
}

class MyDropdownButton extends StatelessWidget {
  final String title;
  final dynamic value;
  final CustomDropdownValue? initialValue;
  final String hint;
  final IconData? icon;
  final void Function(dynamic)? onChanged;
  final List<CustomDropdownValue> items;
  final SingleSelectController<CustomDropdownValue>? controller;
  final String? Function(dynamic)? validator;
  final bool hasSearch;
  final bool isSmall;

  const MyDropdownButton({
    super.key,
    required this.title,
    required this.value,
    required this.hint,
    this.icon,
    this.initialValue,
    required this.onChanged,
    required this.items,
    this.validator,
    this.controller,
    this.isSmall = false,
  }) : hasSearch = false;

  const MyDropdownButton.search({
    super.key,
    required this.title,
    required this.value,
    required this.hint,
    this.icon,
    this.initialValue,
    required this.onChanged,
    required this.items,
    this.validator,
    this.controller,
    this.isSmall = false,
  }) : hasSearch = true;

  @override
  Widget build(BuildContext context) {
    final CustomDropdownDecoration decoration = CustomDropdownDecoration(
      headerStyle: context.myTextStyle(color: context.textPrimary),
      hintStyle: context.myTextStyle(
        color: context.textSecondary,
        size: isSmall ? 10 : 14,
      ),
      listItemStyle: context.myTextStyle(color: context.textSecondary),
      noResultFoundStyle: context.myTextStyle(color: context.textSecondary),
      overlayScrollbarDecoration: const ScrollbarThemeData().copyWith(
        radius: const Radius.circular(100),
        trackColor: WidgetStatePropertyAll(context.onContainer),
      ),
      errorStyle: const TextStyle().copyWith(
        color: context.theme.colorScheme.error,
      ),
      closedBorderRadius: BorderRadius.circular(100),
      closedBorder: BoxBorder.all(color: context.borderPrimary),
      expandedBorder: BoxBorder.all(color: context.borderPrimary),
      expandedBorderRadius: BorderRadius.circular(16),
      closedErrorBorder: BoxBorder.all(color: StatusColors.failure),
      closedErrorBorderRadius: BorderRadius.circular(100),
      expandedFillColor: context.container,
      closedFillColor: context.container,
      searchFieldDecoration: SearchFieldDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: context.borderSecondary),
        ),
        fillColor: context.onContainer,
      ),
      closedSuffixIcon: Icon(
        Icons.arrow_drop_down_rounded,
        color: TextColors.secondary,
        size: isSmall ? 16 : 22,
      ),
      expandedSuffixIcon: Icon(
        Icons.arrow_drop_up_rounded,
        color: TextColors.secondary,
        size: isSmall ? 16 : 22,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: TextColors.secondary, size: 18).paddingRight(4)
          : null,
    );

    if (!hasSearch) {
      return CustomDropdown<CustomDropdownValue>(
        controller: controller,
        initialItem: initialValue,
        validator:
            validator ??
            (s) {
              if (s == null) {
                return '     This field is required';
              }

              return null;
            },
        listItemBuilder: (context, item, isSelected, onItemSelect) =>
            DefaultContainer(
              hasBorder: false,
              radius: 0,
              child: Row(
                spacing: 4,
                children: [
                  Expanded(
                    child: AppText.primary(
                      text: item.value,
                      color: isSelected ? context.green : null,
                      size: isSmall ? 10 : 14,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: context.green,
                      size: isSmall ? 14 : 18,
                    )
                  else
                    Icon(
                      Icons.circle_outlined,
                      color: context.textSecondary,
                      size: isSmall ? 14 : 18,
                    ),
                ],
              ),
            ),
        headerBuilder: (context, selectedItem, enabled) => DefaultContainer(
          padding: EdgeInsets.zero,
          hasBorder: false,
          radius: 0,
          child: Row(
            spacing: 4,
            children: [
              Expanded(
                child: AppText.primary(
                  text: selectedItem.value,
                  size: isSmall ? 10 : 14,
                ),
              ),
            ],
          ),
        ),
        listItemPadding: EdgeInsets.zero,
        items: items,
        onChanged: onChanged,
        canCloseOutsideBounds: true,
        excludeSelected: false,
        hintText: hint,
        closedHeaderPadding: isSmall
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: decoration,
      );
    }

    return CustomDropdown<CustomDropdownValue>.search(
      controller: controller,
      initialItem: initialValue,
      validator:
          validator ??
          (s) {
            if (s == null) {
              return '     This field is required';
            }

            return null;
          },
      listItemBuilder: (context, item, isSelected, onItemSelect) =>
          DefaultContainer(
            hasBorder: false,
            radius: 0,
            child: Row(
              spacing: 4,
              children: [
                Expanded(
                  child: AppText.primary(
                    text: item.value,
                    color: isSelected ? context.green : null,
                    size: isSmall ? 10 : 14,
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: context.green,
                    size: isSmall ? 14 : 18,
                  )
                else
                  Icon(
                    Icons.circle_outlined,
                    color: context.textSecondary,
                    size: isSmall ? 14 : 18,
                  ),
              ],
            ),
          ),
      headerBuilder: (context, selectedItem, enabled) => Row(
        spacing: 4,
        children: [
          Expanded(
            child: AppText.primary(
              text: selectedItem.value,
              size: isSmall ? 10 : 14,
            ),
          ),
        ],
      ),
      listItemPadding: EdgeInsets.zero,
      items: items,
      onChanged: onChanged,
      canCloseOutsideBounds: true,
      excludeSelected: false,
      hintText: hint,
      closedHeaderPadding: isSmall
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: decoration,
    );
  }
}
