import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/helpers/token_storage.dart';
import '../../core/router/routes.dart';
import '../../core/ui/splash/splash.dart';
import '../../core/utils/extensions.dart';
import '../blocs/user_bloc/user_bloc.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();

    _tryRedirect();
  }

  Future<void> _tryRedirect() async {
    final tokenStorage = GetIt.I<TokenStorage>();

    bool onboardingComplete = await tokenStorage.getOnboarding() ?? false;
    String? refreshToken = await tokenStorage.getRefreshToken();

    if (refreshToken.isNull) {
      if (!mounted) return;

      if (onboardingComplete) {
        context.goNamed(Routes.onboarding);
      } else {
        context.goNamed(Routes.auth);
      }
      return;
    } else {
      if (!mounted) return;

      context.read<UserBloc>().add(
        UserFromRefresh(refreshToken: refreshToken!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserAuthenticated) {
          context.goNamed(Routes.dashboard);
        }

        if (state is UserUnauthenticated) {
          context.goNamed(Routes.auth);
        }
      },
      child: const Scaffold(body: SplashPage()),
    );
  }
}
