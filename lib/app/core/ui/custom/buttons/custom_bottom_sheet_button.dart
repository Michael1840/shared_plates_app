import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../../../utils/methods.dart';
import '../containers/default_container.dart';
import '../containers/my_list.dart';
import '../icons/my_icons.dart';
import 'my_icon_button.dart';

class CustomBottomSheetButton<T> extends StatelessWidget {
  final List<T> options;
  final T? selected;
  final ValueChanged<T> onChanged;
  final String Function(T) labelBuilder;
  final String Function(T)? customNameBuilder;
  final Widget? customButton;
  final bool isFilter;
  final String dropdownTitle;

  const CustomBottomSheetButton({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.labelBuilder,
    required this.dropdownTitle,
    this.customButton,
    this.customNameBuilder,
    this.isFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFilter) {
      return GestureDetector(
        onTap: () => _showDropdown(context),
        child: Container(
          padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: BorderColors.primary, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.primary(
                text: selected != null ? labelBuilder(selected as T) : 'Select',
                size: 12,
                weight: Weights.reg,
                color: context.textPrimary,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: context.textPrimary,
                size: 20,
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showDropdown(context),
      child:
          customButton ??
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.container,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.borderPrimary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Expanded(
                  child: AppText.primary(
                    text: selected != null
                        ? labelBuilder(selected as T)
                        : 'Select',
                    size: 12,
                    weight: Weights.reg,
                    color: selected == null
                        ? context.textSecondary
                        : context.textPrimary,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.textPrimary,
                  size: 24,
                ),
              ],
            ),
          ),
    );
  }

  void _showDropdown(BuildContext context) {
    Widget child = Column(
      children: [
        Row(
          spacing: 8,
          mainAxisAlignment: .spaceBetween,
          children: [
            AppText.heading(
              text: dropdownTitle,
              size: 14,
              color: context.primary,
            ),
            MyIconButton(icon: MyIcons.close_md, onTap: () => context.pop()),
          ],
        ),
        Divider(color: context.borderPrimary),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.3,
          ),
          child: MyList(
            scrollPhysics: const AlwaysScrollableScrollPhysics(),
            count: options.length,
            itemBuilder: (context, index) {
              final T selection = options[index];

              bool isSelected = selected == selection;

              return DefaultContainer(
                color: isSelected ? null : Colors.transparent,
                child: Row(
                  spacing: 8,

                  children: [
                    Expanded(
                      child: AppText.primary(
                        text: customNameBuilder != null
                            ? customNameBuilder!(selection)
                            : labelBuilder(selection),
                        size: 14,
                        weight: isSelected ? Weights.medium : Weights.reg,
                        color: context.textPrimary,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: context.primary,
                        size: 16,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );

    Methods.showBottomSheet(
      context,
      child,
      padding: const .only(left: 20, right: 20, bottom: 20),
    );
  }
}

class FilterValue<T> {
  final String name;
  final T value;

  const FilterValue({required this.name, required this.value});
}
