import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants.dart';
import '../buttons/my_icon_button.dart';
import '../icons/my_icons.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      leadingWidth: 100,
      leading: Row(
        children: [
          const SizedBox(width: 20),
          SvgPicture.asset(sharedPlatesSvg, height: 48, width: 48),
        ],
      ),
      actions: [
        const MyIconButton(icon: MyIcons.bell),
        const SizedBox(width: 20),
      ],
    );
  }
}
