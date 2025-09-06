import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/ui/custom/animations/animate_list.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/containers/default_container.dart';
import '../../core/ui/custom/fields/search_field.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';
import 'items/recipe_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leadingWidth: 100,
        leading: Row(
          children: [
            const SizedBox(width: 20),
            CircleAvatar(maxRadius: 24, backgroundColor: context.onContainer),
          ],
        ),
        actions: [
          const MyIconButton(icon: MyIcons.bell),
          const SizedBox(width: 20),
        ],
      ),
      body: PageContainer(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MySliverList(
                customPinnedWidget: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.primary(text: 'Welcome,', color: Colors.white),
                        AppText.heading(
                          text: 'Michael Kiggen',
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Row(
                      spacing: 10,
                      children: [
                        Expanded(child: SearchField()),
                        MyIconButton(icon: MyIcons.heart_02, padding: 14),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 33.64,
                        minHeight: 32.8,
                      ),
                      child: MySliverList.horizontal(
                        gap: 10,
                        itemBuilder: (context, index) => DefaultContainer(
                          color: index == 0 ? context.green : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: AppText.secondary(
                            text: 'Test',
                            color: index == 0 ? context.textPrimary : null,
                            weight: index == 0 ? Weights.bold : Weights.reg,
                          ),
                        ),
                        itemCount: 5,
                      ),
                    ),
                    const SizedBox(),
                  ],
                ).toSliver(),
                itemBuilder: (context, index) => const RecipeItem(),
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
