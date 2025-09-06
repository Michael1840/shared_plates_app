import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import '../containers/default_container.dart';

class MyIconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  final Color? color;
  final bool hasBorder;
  const MyIconTextButton({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
    this.color,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: color ?? context.onContainer,
      borderColor: context.borderSecondary,
      hasBorder: hasBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Icon(icon, color: context.textPrimary, size: 20),
          AppText.primary(text: text, color: context.textPrimary),
        ],
      ),
    ).onTap(onTap);
  }
}
