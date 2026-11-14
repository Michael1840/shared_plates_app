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
  clock('M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7v5l3 2'),
  mail('M4 6h16v12H4zM4 7l8 6 8-6'),
  shield(
    'M12 3l7 3v5c0 4.5-3 8.5-7 10-4-1.5-7-5.5-7-10V6zM9 12l2.5 2.5L15.5 '
    '10',
  ),
  share('M12 15V4M8 8l4-4 4 4M5 13v6a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-6'),
  link(
    'M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1M14 10a4 4 0 0 0-5.7 '
    '0l-3 3a4 4 0 0 0 5.7 5.7l1-1',
  ),
  ruler('M3 16h18v4H3zM7 16v-3M11 16v-4M15 16v-3M19 16v-4'),
  mug('M5 8h12v6a6 6 0 0 1-12 0zM17 10h1.5a2.5 2.5 0 0 1 0 5H17'),
  bolt('M13 3 5 14h6l-1 7 8-11h-6z'),
  coin(
    'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM9.5 16V8.5H13a2 2 0 0 1 0 '
    '4H9.5M12.5 12.5 15 16',
  ),
  bowl('M4 11h16a8 8 0 0 1-16 0zM9 7c0-1 1-1.5 1-3M14 7c0-1 1-1.5 1-3'),
  flame(
    'M12 21c-3.9 0-6.5-2.6-6.5-6.2 0-3.6 3-5.6 3.7-9.3 2.3 1.4 3.5 3.3 '
    '3.6 5.5 1-.6 1.7-1.6 2-2.8 2 1.6 3.7 4 3.7 6.6 0 3.6-2.6 6.2-6.5 6.2z',
  ),
  cake('M4 20h16M5 20v-7h14v7M5 16c2 1.5 4 1.5 7 0s5-1.5 7 0M12 13V9M12 6v.01'),
  leaf('M5 19C5 10 11 5 20 4c0 9-5 15-14 15zM5 19l8-8'),
  box('M4 8h16v11H4zM4 12h16M12 8v11'),
  pasta('M7 3v6a3 3 0 0 0 6 0V3M10 3v18M17 3c-1.5 2-2 5-2 8h2v10'),
  icecream('M8 10a4 4 0 1 1 8 0M7 10h10l-5 11z'),
  egg(
    'M12 20c-4 0-7-3-7-7 0-5 3-9 7-9s7 4 7 9c0 4-3 7-7 7zM12 15a2.5 2.5 0 '
    '1 0 0-5 2.5 2.5 0 0 0 0 5z',
  ),
  chili(
    'M14 6c3 0 5 2 5 5-1 6-8 10-14 9 5-2 7-6 7-10 0-2 .5-4 2-4zM14 6c0-1.5 '
    '1-2.5 2.5-3',
  ),
  ban('M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM5.6 5.6l12.8 12.8'),
  list('M8 6h12M8 12h12M8 18h12M4 6h.01M4 12h.01M4 18h.01'),
  sun(
    'M12 16a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 '
    '17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4',
  ),
  timer('M12 21a8 8 0 1 0 0-16 8 8 0 0 0 0 16zM12 9v4M10 2.5h4'),
  pencil('M4 20h4L19 9l-4-4L4 16zM13.5 6.5l4 4'),
  clipboard('M9 3h6v3H9zM9 4.5H6v16h12v-16h-3M9 11h6M9 15h4'),
  phone(
    'M8 3h8a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1V4a1 1 0 0 1 '
    '1-1zM11 18h2',
  ),
  camera('M4 8h3l2-3h6l2 3h3v11H4zM12 17a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z'),
  grip('M9 6h.01M15 6h.01M9 12h.01M15 12h.01M9 18h.01M15 18h.01'),
  trash('M5 7h14M10 7V4h4v3M7 7l1 13h8l1-13');

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
