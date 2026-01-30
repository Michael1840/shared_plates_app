import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/ui/custom/buttons/my_icon_button.dart';
import '../../core/ui/custom/icons/my_icons.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../blocs/user_bloc/user_bloc.dart';
import 'items/login_sheet.dart';
import 'items/register_sheet.dart';

class AuthSheetPage extends StatefulWidget {
  const AuthSheetPage({super.key});

  @override
  State<AuthSheetPage> createState() => _AuthSheetPageState();
}

class _AuthSheetPageState extends State<AuthSheetPage> {
  late final PageController _pageCont;

  @override
  void initState() {
    super.initState();
    _pageCont = PageController();
  }

  @override
  void dispose() {
    _pageCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background.withValues(alpha: 0.7),
      body: Stack(
        children: [
          // Backdrop blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),
          // Content
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserAuthenticated) {
                context.goNamed(Routes.dashboard);
              }

              if (state is UserUnauthenticated && state.error != null) {
                context.showSnackBarError(state.error!);
                context.read<UserBloc>().add(ClearUserError());
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Row(
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
                SvgPicture.asset(
                  sharedPlatesSvg,
                  width: MediaQuery.sizeOf(context).width * 0.35,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageCont,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: LoginSheet(
                            onTap: () {
                              _pageCont.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              );
                            },
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: RegisterSheet(
                            onTap: () {
                              _pageCont.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOut,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
