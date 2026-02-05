import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../animations/ball_animation.dart';
import '../containers/default_container.dart';

class CustomDropdownValue<T> {
  final T id;
  final String value;

  const CustomDropdownValue({required this.id, required this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomDropdownValue<T> && id == other.id && value == other.value;

  @override
  int get hashCode => id.hashCode ^ value.hashCode;

  @override
  String toString() => 'CustomDropdownValue(id: $id, value: $value)';
}

class MyDropdownButton<T> extends StatelessWidget {
  final String title;
  final dynamic value;
  final String hint;
  final IconData? icon;
  final void Function(CustomDropdownValue<T>?)? onChanged;
  final CustomDropdownValue<T>? initialValue;
  final List<CustomDropdownValue<T>> items;
  final SingleSelectController<CustomDropdownValue<T>>? controller;
  final String? Function(dynamic)? validator;
  final bool hasSearch;
  final bool isSmall;
  final bool isFuture;
  final bool isSearching;
  final Future<List<CustomDropdownValue<T>>> Function(String)? onSearch;
  final double? menuHeight;

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
    this.isSearching = false,
    this.menuHeight,
  }) : hasSearch = false,
       isFuture = false,
       onSearch = null;

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
    this.isSearching = false,
    this.menuHeight,
  }) : hasSearch = true,
       isFuture = false,
       onSearch = null;

  const MyDropdownButton.searchRequest({
    super.key,
    required this.title,
    required this.value,
    required this.hint,
    this.icon,
    this.initialValue,
    required this.onChanged,
    required this.items,
    required this.onSearch,
    this.validator,
    this.controller,
    this.isSmall = false,
    this.isSearching = false,
    this.menuHeight,
  }) : hasSearch = true,
       isFuture = true;

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
        radius: const Radius.circular(20),
        trackColor: WidgetStatePropertyAll(context.onContainer),
      ),
      errorStyle: const TextStyle().copyWith(
        color: context.theme.colorScheme.error,
      ),
      closedBorderRadius: BorderRadius.circular(20),
      closedBorder: BoxBorder.all(color: Colors.transparent),
      expandedBorder: BoxBorder.all(color: Colors.transparent),
      expandedBorderRadius: BorderRadius.circular(20),
      closedErrorBorder: BoxBorder.all(color: StatusColors.failure),
      closedErrorBorderRadius: BorderRadius.circular(20),
      expandedFillColor: context.container,
      closedFillColor: context.container,
      expandedShadow: [],
      closedShadow: [],
      searchFieldDecoration: SearchFieldDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        hintStyle: context.myTextStyle(color: context.textSecondary, size: 12),
        textStyle: context.myTextStyle(color: context.white, size: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.green),
        ),
        fillColor: context.background,
      ),
      closedSuffixIcon: Icon(
        Icons.arrow_drop_down_rounded,
        color: context.textSecondary,
        size: isSmall ? 16 : 22,
      ),
      expandedSuffixIcon: Icon(
        Icons.arrow_drop_up_rounded,
        color: context.textSecondary,
        size: isSmall ? 16 : 22,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: context.textSecondary, size: 18).paddingRight(4)
          : null,
    );

    if (!hasSearch) {
      return CustomDropdown<CustomDropdownValue<T>>(
        controller: controller,
        initialItem: initialValue,
        overlayHeight: menuHeight ?? 200,
        validator:
            validator ??
            (s) {
              if (s == null) {
                return '     This field is required';
              }

              return null;
            },
        listItemBuilder: (context, item, isSelected, onItemSelect) {
          return DefaultContainer(
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
          );
        },
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
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: decoration,
      );
    }

    ////// SEARCHING WITH FUTURE

    if (hasSearch && isFuture) {
      return CustomDropdown<CustomDropdownValue<T>>.searchRequest(
        futureRequest: onSearch,
        controller: controller,
        initialItem: initialValue,
        overlayHeight: menuHeight ?? 200,
        validator:
            validator ??
            (s) {
              if (s == null) {
                return '     This field is required';
              }

              return null;
            },
        searchRequestLoadingIndicator: const DefaultContainer(
          hasBorder: false,
          radius: 0,
          child: Center(child: BallAnimation(ballSize: 10)),
        ),

        noResultFoundBuilder: (context, text) => DefaultContainer(
          hasBorder: false,
          radius: 0,
          child: AppText.primary(
            text:
                'Could not find what you were looking for, try something different.',
            color: context.textSecondary,
            size: isSmall ? 10 : 14,
          ),
        ),

        listItemBuilder: (context, item, isSelected, onItemSelect) {
          return DefaultContainer(
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
          );
        },
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
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: decoration,
      );
    }

    /////// SEARCHING WITHOUT FUTURE

    return CustomDropdown<CustomDropdownValue<T>>.search(
      controller: controller,
      initialItem: initialValue,
      overlayHeight: menuHeight ?? 200,
      validator:
          validator ??
          (s) {
            if (s == null) {
              return '     This field is required';
            }

            return null;
          },

      listItemBuilder: (context, item, isSelected, onItemSelect) {
        if (isSearching) {
          return const DefaultContainer(
            hasBorder: false,
            radius: 0,
            child: Center(child: BallAnimation(ballSize: 15)),
          );
        }

        if (items.isEmpty) {
          return DefaultContainer(
            hasBorder: false,
            radius: 0,
            child: AppText.primary(
              text: 'Start searching to see items',
              color: context.textSecondary,
              size: isSmall ? 10 : 14,
            ),
          );
        }

        return DefaultContainer(
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
        );
      },
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
      searchHintText: 'Smoked Trout...',
      listItemPadding: EdgeInsets.zero,
      items: items,
      onChanged: onChanged,
      canCloseOutsideBounds: true,
      excludeSelected: false,
      hintText: hint,
      closedHeaderPadding: isSmall
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: decoration,
    );
  }
}
