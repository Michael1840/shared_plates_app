import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class HeaderIconButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    super.key,
    this.tone = HeaderTone.paprika,
    this.badge = false,
  });

  final SpIcons icon;
  final String semanticLabel;
  final VoidCallback? onTap;
  final HeaderTone tone;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final ink = HeaderBlock.inkFor(context, tone);
    return CircleIconButton(
      icon: icon,
      semanticLabel: semanticLabel,
      onTap: onTap,
      fill: ink.withValues(alpha: 0.16),
      color: ink,
      badge: badge,
    );
  }
}
