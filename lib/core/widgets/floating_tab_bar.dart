import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';

class TabItem {
  const new({required this.label, required this.icon});

  final String label;
  final SpIcons icon;
}

class FloatingTabBar extends StatelessWidget {
  const new({
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    required this.onCreate,
    super.key,
  });

  static const double overlap = 96;

  final List<TabItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final bottom = math.max<double>(MediaQuery.paddingOf(context).bottom, 12);
    final half = items.length ~/ 2;
    final radius = BorderRadius.circular(Sizes.tabBar / 2);
    return Padding(
      padding: EdgeInsets.fromLTRB(Spacing.m, Spacing.xs, Spacing.m, bottom),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: sp.shadow,
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: Sizes.tabBar,
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
              decoration: BoxDecoration(
                color: sp.tabBarFill,
                borderRadius: radius,
              ),
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i == half)
                      Center(child: _CreateButton(onTap: onCreate)).expand(),
                    _TabButton(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onSelect(i),
                    ).expand(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const new({required this.item, required this.selected, required this.onTap});

  final TabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final color = selected ? sp.tabActive : sp.tabInactive;
    final icon = SpIcon(item.icon, color: color);
    return Semantics(
      selected: selected,
      child: Pressable(
        onTap: onTap,
        semanticLabel: item.label,
        child: AnimatedContainer(
          duration: context.motion(Motion.medium),
          curve: Motion.arrive,
          width: double.infinity,
          height: Sizes.createButton,
          decoration: BoxDecoration(
            color: selected ? sp.tabActivePill : Colors.transparent,
            borderRadius: BorderRadius.circular(Sizes.createButton / 2),
          ),
          child: ExcludeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 3,
              children: [
                if (selected)
                  Entrance(
                    key: ValueKey(item.label),
                    style: EntranceStyle.pop,
                    delay: const Duration(milliseconds: 120),
                    child: icon,
                  )
                else
                  icon,
                AppText(
                  text: item.label,
                  config: FontConfigs.sublabel3,
                  weight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const new({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      semanticLabel: 'Create a recipe',
      child: Container(
        width: Sizes.createButton,
        height: Sizes.createButton,
        decoration: BoxDecoration(
          color: context.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SpIcon(
          SpIcons.plus,
          size: 24,
          strokeWidth: 2.4,
          color: context.onPrimary,
        ),
      ),
    );
  }
}
