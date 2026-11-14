import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class CreateStartPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CircleIconButton(
                    icon: SpIcons.close,
                    semanticLabel: 'Close',
                    onTap: () => context.pop(),
                  ),
                ),
                const Spacer(),
                const Center(
                  child: Paprika(mood: PaprikaMood.thinking, size: 160),
                ),
                const SizedBox(height: Spacing.l),
                const AppText(text: 'New recipe', config: FontConfigs.h1),
                const SizedBox(height: Spacing.xs),
                const AppText.secondary(
                  text: 'Type it, paste it, or pick up a draft.',
                  config: FontConfigs.body1,
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
