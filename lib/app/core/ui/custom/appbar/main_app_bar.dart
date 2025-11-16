import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions.dart';
import '../buttons/my_icon_button.dart';
import '../containers/network_image.dart';
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
        children: [SvgPicture.asset(sharedPlatesSvg, height: 48, width: 48)],
      ),
      actions: [
        const MyIconButton(icon: MyIcons.bell),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: context.textSecondary,
          maxRadius: 16,
          child: MyNetworkImage(
            url: '',
            errorAsset: 'assets/svgs/User/User_02.svg',
          ),
        ),
      ],
    );
  }
}
