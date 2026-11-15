import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/tape.dart';

class GridBadge {
  const GridBadge(this.label, this.fill, this.ink);

  final String label;
  final Color fill;
  final Color ink;
}

class GridPrint extends StatelessWidget {
  const GridPrint({
    required this.title,
    required this.coverStyle,
    required this.index,
    required this.onTap,
    super.key,
    this.imageUrl,
    this.localPath,
    this.meta,
    this.badge,
  });

  static const photoHeight = 116.0;
  static const _tilts = [1.4, 1.0, -1.4, -1.0, 1.2, -1.2];

  final String title;
  final CoverStyle coverStyle;
  final int index;
  final VoidCallback onTap;
  final String? imageUrl;
  final String? localPath;
  final String? meta;
  final GridBadge? badge;

  @override
  Widget build(BuildContext context) {
    final tilt = _tilts[index % _tilts.length];
    final taped = index.isEven;
    final tag = badge;
    final info = meta;
    return Entrance.staggered(
      index: index,
      style: EntranceStyle.print,
      child: Pressable(
        onTap: onTap,
        semanticLabel: [title, ?info].join('. '),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
              decoration: BoxDecoration(
                color: context.container,
                borderRadius: BorderRadius.circular(Rounding.printSmall),
                boxShadow: [
                  BoxShadow(
                    color: context.sp.printShadow,
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 4,
                children: [
                  Stack(
                    children: [
                      RecipeCover(
                        style: coverStyle,
                        imageUrl: imageUrl,
                        localPath: localPath,
                        height: photoHeight,
                        radius: 2,
                      ),
                      if (tag != null)
                        Positioned(
                          left: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: tag.fill,
                              borderRadius: BorderRadius.circular(
                                Rounding.pill,
                              ),
                            ),
                            child: AppText(
                              text: tag.label,
                              config: FontConfigs.sublabel3,
                              weight: FontWeight.w700,
                              color: tag.ink,
                            ),
                          ),
                        ),
                    ],
                  ),
                  AppText(
                    text: title,
                    config: FontConfigs.h5,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ).paddingOnly(left: 2, right: 2, top: 2),
                  if (info != null)
                    AppText.secondary(
                      text: info,
                      config: FontConfigs.sublabel2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).paddingSymmetric(horizontal: 2),
                ],
              ),
            ),
            if (taped)
              const Positioned(
                top: -9,
                left: 0,
                right: 0,
                child: Center(child: Tape(width: 52, height: 16, tilt: -4)),
              ),
          ],
        ),
      ).rotated(tilt),
    );
  }
}

class DraftPrint extends StatelessWidget {
  const DraftPrint({
    required this.title,
    required this.toGo,
    required this.index,
    required this.onTap,
    super.key,
  });

  final String title;
  final int toGo;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final note = switch (toGo) {
      0 => 'ready to share!',
      1 => '1 step to go!',
      _ => '$toGo steps to go!',
    };
    return Entrance.staggered(
      index: index,
      style: EntranceStyle.print,
      child: Pressable(
        onTap: onTap,
        semanticLabel: '$title, draft. $note',
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
          decoration: BoxDecoration(
            color: context.sp.paper,
            borderRadius: BorderRadius.circular(Rounding.printSmall),
            border: Border.all(color: context.sp.handle, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              Container(
                height: GridPrint.photoHeight,
                decoration: BoxDecoration(
                  color: context.sp.honeySoft,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: const Paprika(
                  mood: PaprikaMood.thinking,
                  size: 88,
                  decorative: true,
                  animate: false,
                ),
              ),
              AppText(
                text: 'Draft',
                config: FontConfigs.stampUnitLarge,
                color: context.sp.honeyInk,
              ).paddingOnly(left: 2, top: 2),
              AppText(
                text: title.trim().isEmpty ? 'Untitled recipe' : title,
                config: FontConfigs.h5,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).paddingSymmetric(horizontal: 2),
              HandwrittenNote(
                note,
                animate: false,
              ).paddingSymmetric(horizontal: 2),
            ],
          ),
        ),
      ).rotated(-1.2),
    );
  }
}

class PrintGrid extends StatelessWidget {
  const PrintGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Spacing.gutter,
      children: [
        for (var i = 0; i < children.length; i += 2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Spacing.m,
            children: [
              children[i].expand(),
              if (i + 1 < children.length)
                children[i + 1].expand()
              else
                const Spacer(),
            ],
          ),
      ],
    ).paddingSymmetric(horizontal: 2);
  }
}
