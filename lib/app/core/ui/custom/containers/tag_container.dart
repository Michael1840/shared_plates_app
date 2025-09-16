import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../../utils/extensions.dart';
import 'default_container.dart';

class TagContainer extends StatelessWidget {
  final String title;
  final bool isActive;
  const TagContainer({super.key, required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      color: isActive ? context.green : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: AppText.secondary(
        text: title,
        color: isActive ? context.white : null,
        weight: isActive ? Weights.bold : Weights.reg,
      ),
    );
  }
}
