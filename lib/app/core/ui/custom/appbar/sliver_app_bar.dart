import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import 'main_app_bar.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      // automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 60,
      collapsedHeight: 60,
      expandedHeight: 95,
      actionsPadding: const EdgeInsets.all(0),
      flexibleSpace: Container(
        color: context.background,
        padding: const EdgeInsets.only(bottom: 20),
        child: const MainAppBar(),
      ),
    );
  }
}
