import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions.dart';

class ImageButton extends StatelessWidget {
  final void Function()? onTap;
  final String? customAsset;
  final Widget child;
  const ImageButton({
    super.key,
    this.onTap,
    this.customAsset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: customAsset != null
              ? CachedNetworkImageProvider(customAsset!)
              : const AssetImage(createRecipe2),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ).onTap(onTap);
  }
}
