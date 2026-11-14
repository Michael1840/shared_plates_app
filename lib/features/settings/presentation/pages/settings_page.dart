import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
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
import 'package:shared_plates_app/core/widgets/sheets.dart';
import 'package:shared_plates_app/core/widgets/snackbars.dart';
import 'package:shared_plates_app/core/widgets/sp_icon.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/widgets/edit_profile_sheet.dart';
import 'package:shared_plates_app/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:shared_plates_app/features/settings/presentation/widgets/settings_rows.dart';

class SettingsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<SessionCubit>().state.userId ?? '';
    return BlocProvider(
      create: (_) => SettingsCubit(
        profiles: sl<ProfileRepository>(),
        settings: sl<AppSettingsStore>(),
        userId: uid,
      )..start(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const new({super.key});

  static String providerLabel(String? provider) => switch (provider) {
    'google' => 'Google',
    'apple' => 'Apple',
    'email' => 'Email code',
    _ => 'Email code',
  };

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final session = context.read<SessionCubit>();
    final account = session.account;
    final theme = context.watch<ThemeModeCubit>().state;
    final p = state.profile;
    final firstName = (p?.displayName ?? '').trim().split(' ').first;
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (a, b) => a.errorTick != b.errorTick,
      listener: (context, s) {
        final error = s.error;
        if (error != null) context.showSnackBarError(error);
      },
      child: Scaffold(
        body: DotGridBackground(
          child: CustomScrollView(
            slivers: [
              const _SettingsHeader().toSliver(),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  Spacing.gutter,
                  Spacing.l,
                  Spacing.gutter,
                  MediaQuery.paddingOf(context).bottom + Spacing.xl,
                ),
                sliver: SliverList.list(
                  children: [
                    SettingsGroup(
                      title: 'Account',
                      rows: [
                        LinkRow(
                          label: 'Name and username',
                          value: p == null ? null : '@${p.username}',
                          onTap: p == null
                              ? null
                              : () => unawaited(
                                  context.bottomSheet<void>(
                                    EditProfileSheet(profile: p),
                                  ),
                                ),
                        ),
                        LinkRow(label: 'Email', value: account?.email ?? '–'),
                        LinkRow(
                          label: 'Sign-in method',
                          value: providerLabel(account?.provider),
                        ),
                      ],
                    ),
                    SettingsGroup(
                      title: 'Cooking',
                      rows: [
                        SegmentRow<UnitSystem>(
                          label: 'Units',
                          value: p?.units ?? UnitSystem.metric,
                          options: const {
                            UnitSystem.metric: 'Metric',
                            UnitSystem.imperial: 'Imperial',
                          },
                          onChanged: (u) =>
                              cubit.update(ProfilePreferences(units: u)),
                        ),
                        LinkRow(
                          label: 'Hide recipes with',
                          value: state.avoid.isEmpty
                              ? 'Nothing'
                              : [for (final a in state.avoid) a.label]
                                    .join(', '),
                          onTap: () => unawaited(
                            context.bottomSheet<void>(
                              BlocProvider.value(
                                value: cubit,
                                child: const AvoidSheet(),
                              ),
                            ),
                          ),
                        ),
                        const LinkRow(label: 'Currency', value: 'Rand (R)'),
                        ToggleRow(
                          label: 'Keep screen on in cook mode',
                          value: p?.keepScreenOn ?? true,
                          onChanged: (v) =>
                              cubit.update(ProfilePreferences(keepScreenOn: v)),
                        ),
                      ],
                    ),
                    SettingsGroup(
                      title: 'Sharing',
                      rows: [
                        SegmentRow<RecipeVisibility>(
                          label: 'New recipes are visible to',
                          value:
                              p?.defaultVisibility ?? RecipeVisibility.friends,
                          options: const {
                            RecipeVisibility.public: 'Everyone',
                            RecipeVisibility.friends: 'Friends',
                            RecipeVisibility.private: 'Just me',
                          },
                          onChanged: (v) => cubit.update(
                            ProfilePreferences(defaultVisibility: v),
                          ),
                        ),
                        ToggleRow(
                          label: 'Tell cooks when I make their recipe',
                          sub: firstName.isEmpty
                              ? null
                              : 'They see "$firstName cooked your curry"',
                          value: state.tellCooks,
                          onChanged: (v) => cubit.setTellCooks(value: v),
                        ),
                      ],
                    ),
                    SettingsGroup(
                      title: 'Notifications',
                      rows: [
                        ToggleRow(
                          label: 'Saves and cooks of my recipes',
                          value:
                              (p?.notifySaves ?? true) ||
                              (p?.notifyCooks ?? true),
                          onChanged: (v) => cubit.update(
                            ProfilePreferences(notifySaves: v, notifyCooks: v),
                          ),
                        ),
                        ToggleRow(
                          label: 'Friend requests',
                          value: p?.notifyFriends ?? true,
                          onChanged: (v) => cubit.update(
                            ProfilePreferences(notifyFriends: v),
                          ),
                        ),
                        ToggleRow(
                          label: 'Weekly round-up',
                          value: p?.weeklyRoundup ?? true,
                          onChanged: (v) => cubit.update(
                            ProfilePreferences(weeklyRoundup: v),
                          ),
                        ),
                      ],
                    ),
                    SettingsGroup(
                      title: 'Appearance',
                      rows: [
                        SegmentRow<ThemeMode>(
                          label: 'Theme',
                          value: theme,
                          options: const {
                            ThemeMode.light: 'Light',
                            ThemeMode.dark: 'Dark',
                            ThemeMode.system: 'Match phone',
                          },
                          onChanged: (m) =>
                              context.read<ThemeModeCubit>().set(m),
                        ),
                      ],
                    ),
                    SecondaryButton(
                      label: 'Log out',
                      outlined: true,
                      onTap: () => unawaited(_logOut(context)),
                    ),
                    const SizedBox(height: Spacing.s),
                    Center(
                      child: TextLinkButton(
                        label: 'Delete my account',
                        color: context.primaryDeep,
                        onTap: () => unawaited(_delete(context)),
                      ),
                    ),
                    AppText.secondary(
                      text:
                          'Deleting removes your recipes, likes and saves for '
                          'good.',
                      config: FontConfigs.sublabel2,
                      color: context.textMuted,
                      align: TextAlign.center,
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

  Future<void> _logOut(BuildContext context) async {
    final session = context.read<SessionCubit>();
    context.pop();
    await session.signOut();
  }

  Future<void> _delete(BuildContext context) async {
    final session = context.read<SessionCubit>();
    final confirmed = await context.bottomSheet<bool>(
      const DeleteAccountSheet(),
    );
    if (confirmed != true || !context.mounted) return;
    final error = await session.deleteAccount();
    if (!context.mounted) return;
    if (error != null) context.showSnackBarError(error);
  }
}

class _SettingsHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final ink = context.sp.onHeader;
    return HeaderBlock(
      radius: 36,
      bottomPadding: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: HeaderIconButton(
              icon: SpIcons.chevronLeft,
              semanticLabel: 'Back',
              onTap: () => context.pop(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Entrance(
                    delay: const Duration(milliseconds: 60),
                    child: Semantics(
                      header: true,
                      child: AppText(
                        text: 'Settings',
                        config: FontConfigs.title,
                        color: ink,
                      ),
                    ),
                  ),
                  const HandwrittenNote(
                    'make the kitchen yours',
                    surface: NoteSurface.header,
                    tilt: -2,
                  ),
                ],
              ).expand(),
              Transform.translate(
                offset: const Offset(6, 10),
                child: const Paprika(
                  mood: PaprikaMood.wink,
                  size: 96,
                  tilt: -6,
                  decorative: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
