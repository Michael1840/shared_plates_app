import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';

enum PaprikaMood {
  happy('Paprika smiling'),
  cheer('Paprika cheering'),
  sleepy('Paprika dozing'),
  oops('Paprika looking worried'),
  thinking('Paprika thinking'),
  wink('Paprika winking'),
  proud('Paprika smiling proudly'),
  focused('Paprika concentrating');

  new(this.description);

  final String description;

  String get asset => 'assets/paprika/$name.png';
}

class Paprika extends StatelessWidget {
  const new({
    super.key,
    this.mood = PaprikaMood.happy,
    this.size = 112,
    this.tilt = 0,
    this.animate = true,
    this.delay = const Duration(milliseconds: 240),
    this.decorative = false,
  });

  final PaprikaMood mood;
  final double size;
  final double tilt;
  final bool animate;
  final Duration delay;
  final bool decorative;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      mood.asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: decorative,
      semanticLabel: decorative ? null : mood.description,
      gaplessPlayback: true,
    ).rotated(tilt);
    if (!animate) return image;
    return Entrance(style: EntranceStyle.pop, delay: delay, child: image);
  }
}
