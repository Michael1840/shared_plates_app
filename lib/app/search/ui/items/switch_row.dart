import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utils/extensions.dart';

class SwitchRow extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool b)? onChanged;
  const SwitchRow({
    super.key,
    required this.title,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.primary(text: title),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
            inactiveTrackColor: context.container,
            activeTrackColor: context.primary,
            activeThumbColor: context.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
