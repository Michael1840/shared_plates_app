import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/extensions.dart';

class CircleSvgButton extends StatelessWidget {
  final String asset;
  final void Function()? onTap;
  const CircleSvgButton({super.key, required this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: context.containerInverse,
      ),
      child: SvgPicture.asset(asset, width: 24, height: 24),
    ).onTap(onTap);
  }
}
