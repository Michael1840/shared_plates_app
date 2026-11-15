import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/dot_grid_background.dart';
import 'package:shared_plates_app/core/widgets/handwritten_note.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/entrance.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/speech_bubble.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/presentation/bloc/paste_cubit.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/create_bottom_bar.dart';
import 'package:shared_plates_app/features/create/presentation/widgets/paste_review.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';

class PastePage extends StatelessWidget {
  const PastePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<SessionCubit>().state.userId ?? '';
    final visibility =
        context.read<CurrentProfileCubit>().state?.defaultVisibility ??
        RecipeVisibility.friends;
    return BlocProvider(
      create: (_) => PasteCubit(
        repository: sl<CreateRepository>(),
        userId: uid,
        visibility: visibility,
      ),
      child: const PasteView(),
    );
  }
}

class PasteView extends StatelessWidget {
  const PasteView({super.key});

  Future<void> _continue(BuildContext context) async {
    final cubit = context.read<PasteCubit>();
    final id = await cubit.build();
    if (!context.mounted) return;
    if (id == null) {
      final error = cubit.state.build.error;
      if (error != null) context.showSnackBarError(error);
      return;
    }
    context.pushReplacement(Routes.editRecipe(id));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasteCubit>().state;
    final cubit = context.read<PasteCubit>();
    final review = state.stage == PasteStage.review;
    return PopScope(
      canPop: !review,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) cubit.editText();
      },
      child: Scaffold(
        bottomNavigationBar: CreateBottomBar(
          note: review
              ? 'You can still change everything on the next screen.'
              : null,
          child: review
              ? PrimaryButton(
                  label: 'Looks right, continue',
                  busyLabel: 'Setting it up…',
                  isBusy: state.build.isInProgress,
                  onTap: () => unawaited(_continue(context)),
                )
              : PrimaryButton(label: 'Split it up', onTap: cubit.split),
        ),
        body: DotGridBackground(
          child: CustomScrollView(
            slivers: [
              _PasteHeader(
                review: review,
                onBack: () => review ? cubit.editText() : context.pop(),
              ).toSliver(),
              if (review)
                const PasteReview().toSliver()
              else
                const _PasteInput().toSliver(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasteHeader extends StatelessWidget {
  const _PasteHeader({required this.review, required this.onBack});

  final bool review;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return HeaderBlock(
      radius: 36,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderIconButton(
            icon: SpIcons.chevronLeft,
            semanticLabel: 'Back',
            onTap: onBack,
          ),
          Entrance(
            delay: const Duration(milliseconds: 60),
            child: Semantics(
              header: true,
              child: AppText(
                text: 'Paste a recipe',
                config: FontConfigs.title,
                color: context.sp.onHeader,
              ),
            ),
          ).paddingOnly(top: 10),
          HandwrittenNote(
            review ? 'I did the boring bit for you' : "I'll do the boring bit",
            surface: NoteSurface.header,
            tilt: -2,
          ).paddingOnly(top: 6),
        ],
      ),
    );
  }
}

class _PasteInput extends StatefulWidget {
  const _PasteInput();

  @override
  State<_PasteInput> createState() => _PasteInputState();
}

class _PasteInputState extends State<_PasteInput> {
  late final TextEditingController _controller = TextEditingController(
    text: context.read<PasteCubit>().state.text,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null || text.trim().isEmpty || !mounted) return;
    _controller.text = text;
    context.read<PasteCubit>().setText(text);
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select<PasteCubit, String?>((c) => c.state.error);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Spacing.s,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: Spacing.xs,
          children: [
            Paprika(mood: PaprikaMood.thinking, size: 76, decorative: true),
            Expanded(
              child: SpeechBubble(
                raised: false,
                text:
                    "Paste the whole thing, title and all. I'll sort it into "
                    'ingredients and steps.',
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(Spacing.m),
          decoration: BoxDecoration(
            color: context.container,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: error == null ? Colors.transparent : context.primary,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _controller,
            minLines: 10,
            maxLines: 18,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            onChanged: context.read<PasteCubit>().setText,
            cursorColor: context.primary,
            style: context.textStyle(
              FontConfigs.body3,
              color: context.textPrimary,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText:
                  "Gran's chakalaka\nServes 6\n\n2 tbsp oil\n1 onion, "
                  'diced\n…\n\nFry the onion until soft…',
              hintStyle: context.textStyle(
                FontConfigs.body3,
                color: context.textMuted,
              ),
            ),
          ),
        ),
        if (error != null)
          AppText(
            text: error,
            config: FontConfigs.sublabel1,
            color: context.primaryDeep,
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: SecondaryButton(
            label: 'Paste from clipboard',
            icon: SpIcons.clipboard,
            height: Sizes.minTap,
            outlined: true,
            onTap: () => unawaited(_fromClipboard()),
          ),
        ),
      ],
    ).paddingAll(Spacing.gutter);
  }
}
