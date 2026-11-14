import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';

enum SpIcons {
  home('M4 10.5 12 4l8 6.5V19a1 1 0 0 1-1 1h-4.5v-5.5h-5V20H5a1 1 0 0 1-1-1z'),
  discover('M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM15.5 8.5l-2 5-5 2 2-5z'),
  recipes(
    'M5 4.5A1.5 1.5 0 0 1 6.5 3H19v15H6.5A1.5 1.5 0 0 0 5 19.5zM5 19.5A1.5 '
    '1.5 0 0 0 6.5 21H19v-3M9 7.5h6',
  ),
  friends(
    'M9 11a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7zM2.5 20c.6-3.4 3.2-5.5 '
    '6.5-5.5s5.9 2.1 6.5 5.5M16 4.3a3.5 3.5 0 0 1 0 6.4M18.5 14.8c1.7.7 '
    '2.8 2.5 3 5.2',
  ),
  plus('M12 5v14M5 12h14'),
  search('M11 18a7 7 0 1 0 0-14 7 7 0 0 0 0 14zM20 20l-4-4'),
  filter('M4 7h10M18 7h2M4 17h4M12 17h8M16 5v4M10 15v4'),
  bell('M6 16V11a6 6 0 1 1 12 0v5l1.5 2h-15zM10 20.5a2 2 0 0 0 4 0'),
  bookmark('M6.5 4h11v16l-5.5-4-5.5 4z'),
  heart(
    'M12 20s-7.5-4.5-7.5-10A4.3 4.3 0 0 1 12 7.4 4.3 4.3 0 0 1 19.5 10c0 '
    '5.5-7.5 10-7.5 10z',
  ),
  chevronRight('M9 5l7 7-7 7'),
  chevronLeft('M15 5l-7 7 7 7'),
  close('M6 6l12 12M18 6 6 18'),
  check('M5 12.5l4.5 4.5L19 7.5'),
  clock('M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7v5l3 2');

  new(this.path);

  final String path;
}

class SpIcon extends StatelessWidget {
  const new(
    this.icon, {
    super.key,
    this.size = Sizes.icon,
    this.color,
    this.strokeWidth = 1.9,
    this.filled = false,
  });

  final SpIcons icon;
  final double size;
  final Color? color;
  final double strokeWidth;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? IconTheme.of(context).color ?? Colors.black;
    final fill = filled ? 'currentColor' : 'none';
    return ExcludeSemantics(
      child: SvgPicture.string(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'fill="$fill" stroke="currentColor" stroke-width="$strokeWidth" '
        'stroke-linecap="round" stroke-linejoin="round"> '
        '<path d="${icon.path}"/></svg>',
        width: size,
        height: size,
        theme: SvgTheme(currentColor: tint),
      ),
    );
  }
}
