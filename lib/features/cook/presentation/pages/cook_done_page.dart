import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/cook/data/cook_repository.dart';
import 'package:shared_plates_app/features/cook/domain/cook_args.dart';
import 'package:shared_plates_app/features/cook/presentation/bloc/cook_done_cubit.dart';
import 'package:shared_plates_app/features/cook/presentation/widgets/cook_done_widgets.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';

class CookDonePage extends StatelessWidget {
  const new({required this.args, super.key});

  final CookedArgs args;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    return BlocProvider(
      create: (_) {
        final cubit = CookDoneCubit(
          cooks: sl<CookRepository>(),
          recipes: sl<RecipeDetailRepository>(),
          card: args.card,
          servings: args.servings,
          userId: session.status == SessionStatus.signedIn
              ? session.userId
              : null,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: CookDoneView(coverUrl: args.coverUrl),
    );
  }
}

class CookDoneView extends StatefulWidget {
  const new({super.key, this.coverUrl});

  final String? coverUrl;

  @override
  State<CookDoneView> createState() => _CookDoneViewState();
}

class _CookDoneViewState extends State<CookDoneView> {
  late final AppLifecycleListener _lifecycle;
  late final CookDoneCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CookDoneCubit>();
    _lifecycle = AppLifecycleListener(onPause: _finish);
  }

  void _finish() => unawaited(_cubit.finish());

  @override
  void dispose() {
    _lifecycle.dispose();
    _finish();
    super.dispose();
  }

  void _close() {
    _finish();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  void _home() {
    _finish();
    context.go(Routes.home);
  }

  Future<void> _fork() async {
    final id = await _cubit.saveMyVersion();
    if (!mounted) return;
    if (id == null) {
      final error = _cubit.state.fork.error;
      if (error != null) context.showSnackBarError(error);
      return;
    }
    context
      ..showSnackBarMessage('Saved as your version. Make it yours.')
      ..pushReplacement(Routes.recipeFor(id));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CookDoneCubit>().state;
    final signedIn = context.select<SessionCubit, bool>(
      (c) => c.state.status == SessionStatus.signedIn,
    );
    final name = context.select<CurrentProfileCubit, String?>(
      (c) => c.state?.displayName,
    );
    final card = state.card;
    return PopScope(
      onPopInvokedWithResult: (_, _) => _finish(),
      child: Scaffold(
        body: DotGridBackground(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DoneHeader(
                      name: name,
                      monthCount: state.monthCount,
                      onClose: _close,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: Spacing.s,
                        children: [
                          CookedPrint(card: card, coverUrl: widget.coverUrl),
                          const SizedBox(height: Spacing.xs),
                          if (signedIn && state.canTellCreator)
                            TellCreatorCard(
                              card: card,
                              value: state.toldCreator,
                              locked: state.logged,
                              onChanged: (v) => context
                                  .read<CookDoneCubit>()
                                  .setToldCreator(value: v),
                            ),
                          DoneActions(card: card),
                        ],
                      ).paddingSymmetric(horizontal: Spacing.gutter),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: Spacing.xxs,
                      children: [
                        if (signedIn && !card.isMine)
                          PrimaryButton(
                            label: 'Save my version',
                            busyLabel: 'Saving…',
                            isBusy: state.fork.isInProgress,
                            onTap: () => unawaited(_fork()),
                          ),
                        Center(
                          child: TextLinkButton(
                            label: 'Back to home',
                            color: context.textPrimary,
                            onTap: _home,
                          ),
                        ),
                      ],
                    ).paddingOnly(
                      left: Spacing.gutter,
                      right: Spacing.gutter,
                      bottom: MediaQuery.paddingOf(context).bottom + Spacing.m,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoneHeader extends StatelessWidget {
  const new({
    required this.name,
    required this.monthCount,
    required this.onClose,
    super.key,
  });

  static const _overlap = 24.0;

  final String? name;
  final int? monthCount;
  final VoidCallback onClose;

  String get _title {
    final first = (name ?? '').trim().split(RegExp(r'\s+')).first;
    return first.isEmpty ? 'Nice one!' : 'Nice one, $first!';
  }

  String get _note => switch (monthCount) {
    null => 'dinner is served',
    1 => 'your first this month, chef',
    final n => "that's $n this month, chef",
  };

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    return HeaderBlock(
      bottomPadding: 68 - _overlap,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: CircleIconButton(
              icon: SpIcons.close,
              semanticLabel: 'Close',
              fill: ink.withValues(alpha: 0.16),
              color: ink,
              onTap: onClose,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -_overlap),
            child: Column(
              children: [
                const Paprika(mood: PaprikaMood.cheer, size: 130),
                Semantics(
                  header: true,
                  child: AppText(
                    text: _title,
                    config: FontConfigs.title,
                    color: ink,
                    align: TextAlign.center,
                  ),
                ).paddingOnly(top: 2),
                HandwrittenNote(
                  _note,
                  surface: NoteSurface.header,
                  tilt: -2,
                  align: TextAlign.center,
                ).paddingOnly(top: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
