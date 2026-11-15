import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class SpSearchBar extends StatelessWidget {
  const SpSearchBar({
    super.key,
    this.controller,
    this.hint = 'Search recipes or people',
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.onTap,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final VoidCallback? onTap;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final readOnly = onTap != null;
    return Container(
      height: Sizes.searchBar,
      padding: const EdgeInsets.only(left: Spacing.m, right: 6),
      decoration: BoxDecoration(
        color: sp.searchFill,
        borderRadius: BorderRadius.circular(Rounding.pill),
        boxShadow: [
          BoxShadow(
            color: sp.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SpIcon(SpIcons.search, color: context.textMuted),
          const SizedBox(width: Spacing.s),
          TextField(
            controller: controller,
            autofocus: autofocus,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: TextInputAction.search,
            cursorColor: context.primary,
            style: context.textStyle(
              FontConfigs.body2,
              color: context.textPrimary,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: context.textStyle(
                FontConfigs.body2,
                color: context.textMuted,
              ),
              semanticCounterText: '',
            ),
          ).expand(),
          if (onFilterTap != null) _FilterButton(onTap: onFilterTap),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: 'Filters',
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.sp.filterFill,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SpIcon(SpIcons.filter, size: 18, color: context.sp.filterIcon),
      ),
    );
  }
}
