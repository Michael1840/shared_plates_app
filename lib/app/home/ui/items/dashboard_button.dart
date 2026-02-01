import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import '../../../core/ui/custom/containers/default_container.dart';
import '../../../core/ui/custom/icons/my_icons.dart';
import '../../../core/utils/extensions.dart';

class DashboardButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final void Function() onTap;
  const DashboardButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconColor.withValues(alpha: 0.15),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(weight: Weights.medium, text: title, size: 12),
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: AppText.secondary(text: subtitle, size: 10)),
                  Icon(
                    MyIcons.chevron_right,
                    color: context.textPrimary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).onTap(onTap);
  }
}
