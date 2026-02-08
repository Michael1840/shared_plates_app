import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/theme.dart';
import '../../core/ui/custom/buttons/wide_text_button.dart';
import '../../core/ui/layouts/page_container.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../blocs/user_bloc/user_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _pageCont = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserAuthenticated) {
          context.goNamed(Routes.dashboard);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: Platform.isIOS,
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(foodTableBgPng, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentGeometry.bottomCenter,
                        end: AlignmentGeometry.topCenter,
                        stops: [0.15, 1],
                        colors: [
                          Colors.black,
                          Colors.black.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: PageContainer(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 40,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      Column(
                        spacing: 30,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: context.myTextStyle(
                                weight: Weights.bold,
                                size: 50,
                              ),
                              children: [
                                const TextSpan(text: 'Your'),
                                TextSpan(
                                  text: ' Table',
                                  style: context.myTextStyle(
                                    weight: Weights.bold,
                                    color: context.green,
                                    size: 50,
                                    height: 1,
                                  ),
                                ),
                                const TextSpan(text: '\nis Ready'),
                              ],
                            ),
                          ),
                          AppText.primary(
                            text:
                                'A community where good food is\nshared, eaten and enjoyed.',
                            alignment: TextAlign.center,
                            color: context.white,
                            size: 14,
                          ),
                          WideTextButton(
                            // borderColor: context.borderSecondary,
                            radius: 20,
                            text: 'Get Started',
                            onTap: () {
                              try {
                                debugPrint('Attempting to push to auth sheet');
                                context.pushNamed(Routes.authSheet);
                              } catch (e) {
                                debugPrint(e.toString());
                              }

                              // showModalBottomSheet(
                              //   barrierColor: Colors.black.withValues(
                              //     alpha: 0.6,
                              //   ),
                              //   backgroundColor: context.background
                              //       .withValues(alpha: 0.7),
                              //   isDismissible: false,
                              //   isScrollControlled: true,
                              //   enableDrag: false,
                              //   useSafeArea: false,
                              //   context: context,
                              //   sheetAnimationStyle: AnimationStyle(
                              //     duration: 500.ms,
                              //     curve: Curves.easeIn,
                              //   ),
                              //   shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadiusGeometry.zero,
                              //   ),
                              //   builder: (ctx) => BackdropFilter(
                              //     filter: ImageFilter.blur(
                              //       sigmaX: 8,
                              //       sigmaY: 8,
                              //     ),
                              //     child: BlocListener<UserBloc, UserState>(
                              //       listener: (ctx, state) {
                              //         if (state is UserAuthenticated) {
                              //           Navigator.pop(context);
                              //           context.goNamed(Routes.dashboard);
                              //         }

                              //         if (state is UserUnauthenticated &&
                              //             state.error != null) {
                              //           context.showSnackBarError(
                              //             state.error!,
                              //           );
                              //         }
                              //       },
                              //       child: Column(
                              //         mainAxisSize: MainAxisSize.max,
                              //         children: [
                              //           Padding(
                              //             padding: const EdgeInsets.only(
                              //               left: 20,
                              //               right: 20,
                              //               top: 20,
                              //             ),
                              //             child: Row(
                              //               children: [
                              //                 MyIconButton(
                              //                   icon: MyIcons.chevron_left,
                              //                   onTap: () {
                              //                     context.pop();
                              //                   },
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //           SvgPicture.asset(
                              //             sharedPlatesSvg,
                              //             width:
                              //                 MediaQuery.sizeOf(
                              //                   context,
                              //                 ).width *
                              //                 0.35,
                              //           ),
                              //           const SizedBox(height: 40),
                              //           Expanded(
                              //             child: PageView(
                              //               physics:
                              //                   const NeverScrollableScrollPhysics(),
                              //               controller: _pageCont,
                              //               children: [
                              //                 SingleChildScrollView(
                              //                   child: Padding(
                              //                     padding: EdgeInsets.only(
                              //                       bottom: MediaQuery.of(
                              //                         ctx,
                              //                       ).viewInsets.bottom,
                              //                     ),
                              //                     child: LoginSheet(
                              //                       onTap: () {
                              //                         _pageCont.animateToPage(
                              //                           1,
                              //                           duration:
                              //                               const Duration(
                              //                                 milliseconds:
                              //                                     250,
                              //                               ),
                              //                           curve: Curves.easeOut,
                              //                         );
                              //                       },
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 SingleChildScrollView(
                              //                   child: Padding(
                              //                     padding: EdgeInsets.only(
                              //                       bottom: MediaQuery.of(
                              //                         ctx,
                              //                       ).viewInsets.bottom,
                              //                     ),
                              //                     child: RegisterSheet(
                              //                       onTap: () {
                              //                         _pageCont.animateToPage(
                              //                           0,
                              //                           duration:
                              //                               const Duration(
                              //                                 milliseconds:
                              //                                     250,
                              //                               ),
                              //                           curve: Curves.easeOut,
                              //                         );
                              //                       },
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // );
                            },
                          ).animate(delay: 750.ms).fadeIn(duration: 500.ms).slideY(begin: 1, end: 0, duration: 500.ms),

                          // WideTextButton(
                          //       radius: 40,
                          //       text: 'Sign Up',
                          //       onTap: () {
                          //         showModalBottomSheet(
                          //           barrierColor: Colors.black.withValues(alpha: 0.6),
                          //           backgroundColor: context.background,
                          //           isScrollControlled: true,
                          //           isDismissible: true,
                          //           useSafeArea: true,
                          //           context: context,
                          //           sheetAnimationStyle: AnimationStyle(
                          //             duration: 500.ms,
                          //             curve: Curves.easeIn,
                          //           ),
                          //           builder: (ctx) => BlocListener<UserBloc, UserState>(
                          //             listener: (ctx, state) {
                          //               if (state is UserAuthenticated) {
                          //                 ctx.goNamed(Routes.dashboard);
                          //               }

                          //               if (state is UserUnauthenticated &&
                          //                   state.error != null) {
                          //                 ctx.showSnackBarError(state.error!);
                          //               }
                          //             },
                          //             child: Padding(
                          //               padding: EdgeInsets.only(
                          //                 bottom: MediaQuery.of(ctx).viewInsets.bottom,
                          //               ),
                          //               child: const SingleChildScrollView(
                          //                 child: RegisterSheet(),
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //     )
                          //     .animate(delay: 1000.ms)
                          //     .fadeIn(duration: 500.ms)
                          //     .slideY(begin: 1, end: 0, duration: 500.ms),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     AppText.primary(
                          //       text: 'Need an account? ',
                          //       alignment: TextAlign.center,
                          //       color: context.white,
                          //       size: 12,
                          //     ),
                          //     AppText.heading(
                          //       text: 'Sign Up',
                          //       alignment: TextAlign.center,
                          //       color: context.white,
                          //       size: 12,
                          //     ).onTap(() {
                          //       showModalBottomSheet(
                          //         barrierColor: Colors.black.withValues(
                          //           alpha: 0.6,
                          //         ),
                          //         backgroundColor: context.background,
                          //         isScrollControlled: true,
                          //         isDismissible: true,
                          //         useSafeArea: true,
                          //         context: context,
                          //         sheetAnimationStyle: AnimationStyle(
                          //           duration: 500.ms,
                          //           curve: Curves.easeIn,
                          //         ),
                          //         builder: (ctx) =>
                          //             BlocListener<UserBloc, UserState>(
                          //               listener: (ctx, state) {
                          //                 if (state is UserAuthenticated) {
                          //                   ctx.goNamed(Routes.dashboard);
                          //                 }

                          //                 if (state is UserUnauthenticated &&
                          //                     state.error != null) {
                          //                   ctx.showSnackBarError(state.error!);
                          //                 }
                          //               },
                          //               child: Padding(
                          //                 padding: EdgeInsets.only(
                          //                   bottom: MediaQuery.of(
                          //                     ctx,
                          //                   ).viewInsets.bottom,
                          //                 ),
                          //                 child: const SingleChildScrollView(
                          //                   child: RegisterSheet(),
                          //                 ),
                          //               ),
                          //             ),
                          //       );
                          //     }),
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText.primary(
                                text: 'By proceeding you are accepting our ',
                                alignment: TextAlign.center,
                                color: context.white,
                                size: 8,
                              ),
                              AppText.heading(
                                text: 'Terms of Service',
                                alignment: TextAlign.center,
                                color: context.white,
                                size: 8,
                              ).onTap(() {}),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
