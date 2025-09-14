import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/buttons/wide_text_button.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../blocs/user_bloc/user_bloc.dart';
import 'items/login_sheet.dart';
import 'items/register_sheet.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserAuthenticated) {
          context.goNamed(Routes.dashboard);
        }

        if (state is UserAuthenticated && state.error != null) {
          context.showSnackBarError(state.error!);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageContainer(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
            bottom: 40,
          ),
          child: Column(
            children: [
              Expanded(
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          sharedPlatesSvg,
                          height: MediaQuery.sizeOf(context).height * 0.20,
                        ),
                        AppText.heading(
                          text: 'Shared Plates',
                          alignment: TextAlign.center,
                          color: context.green,
                          size: 28,
                        ),
                      ],
                    ),
                  )
                  .animate(delay: 250.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 1, end: 0, duration: 500.ms),
              Column(
                spacing: 10,
                children: [
                  WideTextButton(
                        color: context.containerInverse,
                        textColor: context.darkText,
                        radius: 40,
                        text: 'Login',
                        onTap: () {
                          showModalBottomSheet(
                            barrierColor: Colors.black.withValues(alpha: 0.6),
                            backgroundColor: context.background,
                            isDismissible: true,
                            isScrollControlled: true,
                            useSafeArea: true,
                            context: context,
                            sheetAnimationStyle: AnimationStyle(
                              duration: 500.ms,
                              curve: Curves.easeIn,
                            ),
                            builder: (ctx) => BlocListener<UserBloc, UserState>(
                              listener: (ctx, state) {
                                if (state is UserAuthenticated) {
                                  ctx.goNamed(Routes.dashboard);
                                }

                                if (state is UserUnauthenticated &&
                                    state.error != null) {
                                  ctx.showSnackBarError(state.error!);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                                ),
                                child: const SingleChildScrollView(
                                  child: LoginSheet(),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      .animate(delay: 750.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 1, end: 0, duration: 500.ms),
                  WideTextButton(
                        radius: 40,
                        text: 'Sign Up',
                        onTap: () {
                          showModalBottomSheet(
                            barrierColor: Colors.black.withValues(alpha: 0.6),
                            backgroundColor: context.background,
                            isScrollControlled: true,
                            isDismissible: true,
                            useSafeArea: true,
                            context: context,
                            sheetAnimationStyle: AnimationStyle(
                              duration: 500.ms,
                              curve: Curves.easeIn,
                            ),
                            builder: (ctx) => BlocListener<UserBloc, UserState>(
                              listener: (ctx, state) {
                                if (state is UserAuthenticated) {
                                  ctx.goNamed(Routes.dashboard);
                                }

                                if (state is UserUnauthenticated &&
                                    state.error != null) {
                                  ctx.showSnackBarError(state.error!);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                                ),
                                child: const SingleChildScrollView(
                                  child: RegisterSheet(),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      .animate(delay: 1000.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 1, end: 0, duration: 500.ms),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
