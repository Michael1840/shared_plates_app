import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/pop_on_change.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/time_stamp.dart';

class RecipePrintCard extends StatelessWidget {
  const new({
    required this.title,
    required this.coverStyle,
    super.key,
    this.imageUrl,
    this.localPath,
    this.note,
    this.minutes,
    this.likes,
    this.priceLabel,
    this.isSaved = false,
    this.tilt = -1.8,
    this.tapeTilt,
    this.width = 224,
    this.photoHeight = 160,
    this.onTap,
    this.onSave,
    this.animate = true,
    this.delay = const Duration(milliseconds: 160),
  });

  final String title;
  final CoverStyle coverStyle;
  final String? imageUrl;
  final String? localPath;
  final String? note;
  final int? minutes;
  final int? likes;
  final String? priceLabel;
  final bool isSaved;
  final double tilt;
  final double? tapeTilt;
  final double width;
  final double photoHeight;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool animate;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final noteText = note;
    final meta = [if (likes != null) '$likes', ?priceLabel].join(' · ');
    return Pressable(
      onTap: onTap,
      semanticLabel: title,
      child: PhotoPrint(
        tilt: tilt,
        tapeTilt: tapeTilt,
        width: width,
        animate: animate,
        delay: delay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _PrintPhoto(
              coverStyle: coverStyle,
              imageUrl: imageUrl,
              localPath: localPath,
              height: photoHeight,
              minutes: minutes,
              isSaved: isSaved,
              onSave: onSave,
              animate: animate,
            ),
            const SizedBox(height: Spacing.xs),
            AppText(
              text: title,
              config: FontConfigs.h4,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ).paddingSymmetric(horizontal: Spacing.xxs),
            if (noteText != null)
              HandwrittenNote(
                noteText,
                animate: animate,
              ).paddingOnly(left: Spacing.xxs, right: Spacing.xxs, top: 6),
            if (meta.isNotEmpty)
              _PrintMeta(
                text: meta,
                showHeart: likes != null,
              ).paddingOnly(left: Spacing.xxs, right: Spacing.xxs, top: 8),
          ],
        ),
      ),
    );
  }
}

class _PrintPhoto extends StatelessWidget {
  const new({
    required this.coverStyle,
    required this.imageUrl,
    required this.localPath,
    required this.height,
    required this.minutes,
    required this.isSaved,
    required this.onSave,
    required this.animate,
  });

  final CoverStyle coverStyle;
  final String? imageUrl;
  final String? localPath;
  final double height;
  final int? minutes;
  final bool isSaved;
  final VoidCallback? onSave;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final mins = minutes;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        RecipeCover(
          style: coverStyle,
          imageUrl: imageUrl,
          localPath: localPath,
          height: height,
        ),
        if (onSave != null)
          Positioned(
            top: 0,
            right: 0,
            child: _SaveBadge(isSaved: isSaved, onTap: onSave),
          ),
        if (mins != null)
          Positioned(
            right: -14,
            bottom: -18,
            child: TimeStamp(minutes: mins, animate: animate),
          ),
      ],
    );
  }
}

class _SaveBadge extends StatelessWidget {
  const new({required this.isSaved, required this.onTap});

  final bool isSaved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fill = isSaved ? context.primary : context.container;
    final ink = isSaved ? context.onPrimary : context.textPrimary;
    return Pressable(
      onTap: onTap,
      semanticLabel: isSaved ? 'Remove from saved' : 'Save recipe',
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: PopOnChange(
          value: isSaved,
          child: SpIcon(
            SpIcons.bookmark,
            size: 16,
            color: ink,
            filled: isSaved,
          ),
        ),
      ),
    );
  }
}

class _PrintMeta extends StatelessWidget {
  const new({required this.text, required this.showHeart});

  final String text;
  final bool showHeart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showHeart) ...[
          SpIcon(SpIcons.heart, size: 14, color: context.primary, filled: true),
          const SizedBox(width: 6),
        ],
        AppText.secondary(
          text: text,
          config: FontConfigs.sublabel2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).flexible(),
      ],
    );
  }
}
