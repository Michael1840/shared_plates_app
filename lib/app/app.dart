import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_plates_app/app/di.dart';
import 'package:shared_plates_app/app/router/app_router.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/theme/app_theme.dart';
import 'package:shared_plates_app/features/activity/data/activity_repository.dart';
import 'package:shared_plates_app/features/activity/presentation/bloc/activity_cubit.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/auth/presentation/bloc/session_cubit.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/profile/presentation/bloc/current_profile_cubit.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_actions_repository.dart';
import 'package:shared_plates_app/features/recipe/presentation/bloc/recipe_actions_cubit.dart';
import 'package:shared_plates_app/features/settings/presentation/bloc/settings_cubit.dart';

class SharedPlatesApp extends StatefulWidget {
  const SharedPlatesApp({super.key});

  @override
  State<SharedPlatesApp> createState() => _SharedPlatesAppState();
}

class _SharedPlatesAppState extends State<SharedPlatesApp> {
  late final SessionCubit _session = SessionCubit(
    auth: sl<AuthRepository>(),
    profiles: sl<ProfileRepository>(),
    settings: sl<AppSettingsStore>(),
    sync: sl<SyncService>(),
    db: sl<AppDatabase>(),
  );
  late final CurrentProfileCubit _profile = CurrentProfileCubit(
    profiles: sl<ProfileRepository>(),
    session: _session,
  );
  late final RecipeActionsCubit _actions = RecipeActionsCubit(
    actions: sl<RecipeActionsRepository>(),
    session: _session,
  );
  late final ThemeModeCubit _theme = ThemeModeCubit(sl<AppSettingsStore>());
  late final ActivityBadgeCubit _badge = ActivityBadgeCubit(
    activity: sl<ActivityRepository>(),
  );
  late final GoRouter _router = buildRouter(_session);

  @override
  void initState() {
    super.initState();
    unawaited(_session.start());
  }

  @override
  void dispose() {
    _router.dispose();
    unawaited(_profile.close());
    unawaited(_actions.close());
    unawaited(_theme.close());
    unawaited(_badge.close());
    unawaited(_session.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _session),
        BlocProvider.value(value: _profile),
        BlocProvider.value(value: _actions),
        BlocProvider.value(value: _theme),
        BlocProvider.value(value: _badge),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp.router(
          title: 'SharedPlates',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          routerConfig: _router,
        ),
      ),
    );
  }
}
