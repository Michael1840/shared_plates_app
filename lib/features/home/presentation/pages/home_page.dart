import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/env.dart';
import 'package:shared_plates_app/app/router/routes.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/theme/app_text.dart';
import 'package:shared_plates_app/core/theme/sizing.dart';
import 'package:shared_plates_app/core/theme/typography.dart';
import 'package:shared_plates_app/core/utils/extensions.dart';
import 'package:shared_plates_app/core/widgets/buttons.dart';
import 'package:shared_plates_app/core/widgets/header_icon_button.dart';
import 'package:shared_plates_app/core/widgets/motion/pressable.dart';
import 'package:shared_plates_app/core/widgets/paprika.dart';
import 'package:shared_plates_app/core/widgets/paprika_header.dart';
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/core/widgets/sp_search_bar.dart';
import 'package:shared_plates_app/core/widgets/sticky_note.dart';
import 'package:shared_plates_app/core/widgets/tab_page.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/home/data/checklist_repository.dart';
import 'package:shared_plates_app/features/home/presentation/bloc/checklist_cubit.dart';
import 'package:shared_plates_app/features/home/presentation/widgets/first_run_checklist.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/profile/presentation/widgets/account_sheet.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.select<SessionCubit, String?>((c) => c.state.userId);
    return BlocProvider(
      key: ValueKey(uid),
      create: (_) {
        final cubit = ChecklistCubit(sl<ChecklistRepository>());
        if (uid != null) cubit.watch(uid);
        return cubit;
      },
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const new();

  static String greetingFor(DateTime now, String? name) {
    final hour = now.hour;
    final part = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    final first = name?.trim().split(RegExp(r'\s+')).first;
    return first == null || first.isEmpty ? part : '$part, $first';
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final profile = context.watch<CurrentProfileCubit>().state;
    final checklist = context.watch<ChecklistCubit>().state;
    final guest = session.status == SessionStatus.guest;
    final showChecklist =
        checklist != null && !checklist.dismissed && !checklist.complete;
    return TabPage(
      header: PaprikaHeader(
        greeting: guest
            ? 'Welcome'
            : greetingFor(DateTime.now(), profile?.displayName),
        title: "What's cooking tonight?",
        note: 'braai weather,\njust saying',
        actions: [
          if (!guest)
            HeaderIconButton(
              icon: SpIcons.bell,
              semanticLabel: 'Activity',
              onTap: () {},
            ),
          _AvatarButton(profile: profile, guest: guest),
        ],
        search: SpSearchBar(onTap: () {}, onFilterTap: () {}),
      ),
      children: [
        if (guest)
          StickyNote(
            title: 'Just looking?',
            body: 'Sign in to save recipes and share your own.',
            actions: [
              CompactButton(
                label: 'Sign in',
                onTap: () => context.read<SessionCubit>().leaveGuest(),
              ),
            ],
          )
        else if (showChecklist)
          FirstRunChecklist(
            progress: checklist,
            onDismiss: () => context.read<ChecklistCubit>().dismiss(),
          )
        else
          const StickyNote(
            title: 'Fresh start.',
            body: 'Recipes from your people will land here soon.',
            mood: PaprikaMood.happy,
          ),
        if (Env.isDev)
          TextLinkButton(
            label: 'Open widget gallery',
            onTap: () => context.push(Routes.gallery),
          ).paddingOnly(top: Spacing.l),
      ],
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const new({required this.profile, required this.guest});

  final Profile? profile;
  final bool guest;

  String get _initials {
    final parts = (profile?.displayName ?? '').trim().split(RegExp(r'\s+'));
    final letters = [
      for (final p in parts.take(2))
        if (p.isNotEmpty) p[0],
    ].join();
    return letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.sp;
    final initials = _initials;
    return Pressable(
      semanticLabel: guest ? 'Sign in' : 'Your account',
      onTap: () {
        if (guest) {
          unawaited(context.read<SessionCubit>().leaveGuest());
          return;
        }
        unawaited(
          context.bottomSheet<void>(
            AccountSheet(
              profile: profile,
              session: context.read<SessionCubit>(),
            ),
          ),
        );
      },
      child: Container(
        width: Sizes.minTap,
        height: Sizes.minTap,
        decoration: BoxDecoration(color: sp.onHeader, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: initials.isEmpty || guest
            ? SpIcon(SpIcons.friends, size: 20, color: sp.primaryDeep)
            : AppText(
                text: initials,
                config: FontConfigs.body2,
                weight: FontWeight.w700,
                color: context.isDark ? sp.header : sp.primaryDeep,
              ),
      ),
    );
  }
}
