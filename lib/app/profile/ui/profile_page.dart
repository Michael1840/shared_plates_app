import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/blocs/user_bloc/user_bloc.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/buttons/wide_text_button.dart';
import '../../core/ui/custom/containers/network_image.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/extensions.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          children: [
            MyIconButton(
              icon: MyIcons.chevron_left,
              onTap: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: Platform.isIOS,
        bottom: false,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is! UserAuthenticated) {
              return SizedBox();
            }

            return PageContainer(
              child: Column(
                spacing: 20,
                children: [
                  Hero(
                    tag: 'profile-image',
                    child: CircleAvatar(
                      backgroundColor: context.textSecondary,
                      maxRadius: 64,
                      child: const MyNetworkImage(
                        url: '',
                        radius: 128,
                        errorAsset: 'assets/images/image_1.png',
                      ),
                    ),
                  ),
                  Column(
                    spacing: 8,
                    children: [
                      AppText.heading(text: state.user.displayName),
                      AppText.secondary(text: state.user.username),
                    ],
                  ),
                  Column(
                    spacing: 8,
                    children: [
                      WideTextButton(text: 'Profile', color: context.container),
                      WideTextButton(
                        text: 'Settings',
                        color: context.container,
                      ),
                      WideTextButton(text: 'Theme', color: context.container),
                    ],
                  ),
                  const Spacer(),
                  WideTextButton(
                    text: 'Log Out',
                    onTap: () {
                      context.read<UserBloc>().add(UserLogout());
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
