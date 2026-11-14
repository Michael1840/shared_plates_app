import 'package:flutter/material.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';

class Tape extends StatelessWidget {
  const new({super.key, this.width = 72, this.height = 22, this.tilt = 3});

  final double width;
  final double height;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: width,
        height: height,
        child: ColoredBox(color: context.sp.tape),
      ).rotated(tilt),
    );
  }
}
