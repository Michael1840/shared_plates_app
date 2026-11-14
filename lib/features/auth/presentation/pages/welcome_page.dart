import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/motion.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/photo_print.dart';
import 'package:shared_plates_app/core/widgets/recipe_cover.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/social_sign_in_cubit.dart';

class WelcomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SocialSignInCubit(sl<AuthRepository>()),
      child: BlocListener<SocialSignInCubit, SocialSignInState>(
        listenWhen: (a, b) => b.launch.isError && a.launch != b.launch,
        listener: (context, state) =>
            context.showSnackBarError(state.launch.error ?? ''),
        child: const Scaffold(body: DotGridBackground(child: _WelcomeBody())),
      ),
    );
  }
}

class _WelcomeBody extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _WelcomeHeader()),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(28, Spacing.gutter, 28, bottom + 24),
            child: const Column(
              children: [
                AppText.secondary(
                  text: 'Save the ones you love and share your own.',
                  config: FontConfigs.body1,
                  align: TextAlign.center,
                ),
                Spacer(),
                _SignInOptions(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    return HeaderBlock(
      radius: 48,
      bottomPadding: Spacing.xl,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              SvgPicture.asset(
                'assets/brand/logo.svg',
                width: 36,
                height: 36,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              AppText(
                text: 'SharedPlates',
                config: FontConfigs.brand,
                color: ink,
              ),
            ],
          ).paddingOnly(top: Spacing.l),
          const SizedBox(height: 270, child: _Collage()).paddingOnly(top: 12),
          Entrance(
            delay: const Duration(milliseconds: 60),
            child: AppText(
              text: 'The recipes your people actually cook.',
              config: FontConfigs.hero,
              color: ink,
              align: TextAlign.center,
            ),
          ).paddingOnly(top: Spacing.xs),
        ],
      ),
    );
  }
}

class _Collage extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -4,
          top: 18,
          child: _MiniPrint(style: CoverStyle.stew, tilt: -9, tape: 4),
        ),
        Positioned(
          right: -4,
          top: 6,
          child: _MiniPrint(style: CoverStyle.meat, tilt: 8, tape: -5),
        ),
        Positioned(
          right: 14,
          top: 150,
          child: _MiniPrint(
            style: CoverStyle.sweet,
            tilt: -5,
            tape: 3,
            width: 104,
          ),
        ),
        Align(alignment: Alignment(0, 0.6), child: _BobbingPaprika()),
        Positioned(
          left: 6,
          top: 176,
          child: HandwrittenNote(
            'pull up\na chair!',
            surface: NoteSurface.header,
            large: true,
            tilt: -8,
          ),
        ),
      ],
    );
  }
}

class _MiniPrint extends StatelessWidget {
  const new({
    required this.style,
    required this.tilt,
    required this.tape,
    this.width = 124,
  });

  final CoverStyle style;
  final double tilt;
  final double tape;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: PhotoPrint(
        width: width,
        tilt: tilt,
        tapeTilt: tape,
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 18),
        radius: 4,
        child: RecipeCover(style: style, height: 84, radius: 2),
      ),
    );
  }
}

class _BobbingPaprika extends StatefulWidget {
  const new();

  @override
  State<_BobbingPaprika> createState() => _BobbingPaprikaState();
}

class _BobbingPaprikaState extends State<_BobbingPaprika>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -6 * Curves.easeInOut.transform(_controller.value)),
        child: child,
      ),
      child: const Paprika(size: 192),
    );
  }
}

class _SignInOptions extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final social = context.watch<SocialSignInCubit>().state;
    final busy = social.launch.isInProgress;
    return Column(
      spacing: 14,
      children: [
        PrimaryButton(
          label: 'Continue with email',
          onTap: () => context.push(Routes.signIn),
        ),
        Row(
          spacing: Spacing.s,
          children: [
            Divider(color: context.sp.fieldBorder).expand(),
            const AppText.secondary(text: 'or', config: FontConfigs.sublabel1),
            Divider(color: context.sp.fieldBorder).expand(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Spacing.gutter,
          children: [
            _SocialButton(
              provider: SocialProvider.apple,
              busy: busy && social.provider == SocialProvider.apple,
            ),
            _SocialButton(
              provider: SocialProvider.google,
              busy: busy && social.provider == SocialProvider.google,
            ),
          ],
        ),
        TextLinkButton(
          label: 'Look around first',
          color: context.primaryDeep,
          onTap: () => context.read<SessionCubit>().continueAsGuest(),
        ),
        if (Env.hasTestAccount)
          TextLinkButton(
            label: 'Dev: sign in as ${Env.testEmail}',
            color: context.textMuted,
            onTap: busy
                ? null
                : () => context.read<SocialSignInCubit>().signInWithTestAccount(
                    email: Env.testEmail,
                    password: Env.testPassword,
                  ),
          ),
        const AppText.secondary(
          text: 'By continuing you agree to our Terms and Privacy Policy.',
          config: FontConfigs.sublabel2,
          align: TextAlign.center,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const new({required this.provider, required this.busy});

  final SocialProvider provider;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final apple = provider == SocialProvider.apple;
    return Pressable(
      onTap: busy
          ? null
          : () => context.read<SocialSignInCubit>().signIn(provider),
      semanticLabel: apple ? 'Continue with Apple' : 'Continue with Google',
      child: AnimatedOpacity(
        opacity: busy ? 0.6 : 1,
        duration: context.motion(Motion.small),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: apple ? const Color(0xFF17110E) : context.container,
            shape: BoxShape.circle,
            border: apple
                ? null
                : Border.all(color: context.sp.fieldBorder, width: 1.5),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            apple ? 'assets/brand/apple.svg' : 'assets/brand/google.svg',
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}
