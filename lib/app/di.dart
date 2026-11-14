import 'dart:async';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:get_it/get_it.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';
import 'package:shared_plates_app/core/sync/connectivity_service.dart';
import 'package:shared_plates_app/core/sync/offline_remote_store.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/supabase_remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/screen_awake.dart';
import 'package:shared_plates_app/features/auth/data/auth_repository.dart';
import 'package:shared_plates_app/features/browse/data/browse_api.dart';
import 'package:shared_plates_app/features/browse/data/browse_repository.dart';
import 'package:shared_plates_app/features/cook/data/cook_repository.dart';
import 'package:shared_plates_app/features/create/data/create_repository.dart';
import 'package:shared_plates_app/features/create/data/photo_store.dart';
import 'package:shared_plates_app/features/home/data/checklist_repository.dart';
import 'package:shared_plates_app/features/profile/data/profile_repository.dart';
import 'package:shared_plates_app/features/recipe/data/cover_cache.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_actions_repository.dart';
import 'package:shared_plates_app/features/recipe/data/recipe_detail_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

void configureDependencies({required SupabaseClient? supabase}) {
  final db = AppDatabase.open();
  final connectivity = ConnectivityService();
  final outbox = OutboxStore(db);
  final settings = AppSettingsStore(db);
  final remote = _remoteFor(supabase);
  final sync = SyncService(
    db: db,
    outbox: outbox,
    remote: remote,
    online: connectivity.onlineChanges,
  );
  sl
    ..registerSingleton<AppDatabase>(db, dispose: (d) => d.close())
    ..registerSingleton<ConnectivityService>(connectivity)
    ..registerSingleton<OutboxStore>(outbox)
    ..registerSingleton<AppSettingsStore>(settings)
    ..registerSingleton<RemoteStore>(remote)
    ..registerSingleton<SyncService>(sync, dispose: (s) => s.dispose())
    ..registerSingleton<AuthRepository>(
      supabase == null
          ? const UnavailableAuthRepository()
          : SupabaseAuthRepository(supabase),
    )
    ..registerSingleton<ProfileRepository>(
      ProfileRepositoryImpl(
        db: db,
        outbox: outbox,
        remote: remote,
        sync: sync,
        settings: settings,
      ),
    )
    ..registerSingleton<ChecklistRepository>(
      ChecklistRepositoryImpl(db, settings),
    )
    ..registerSingleton<BrowseRepository>(
      BrowseRepositoryImpl(
        api: supabase == null
            ? const OfflineBrowseApi()
            : SupabaseBrowseApi(supabase),
        db: db,
        outbox: outbox,
        currentUserId: () => remote.userId,
      ),
    )
    ..registerSingleton<RecipeActionsRepository>(
      RecipeActionsRepositoryImpl(db: db, outbox: outbox, sync: sync),
    );
  final browseApi = supabase == null
      ? const OfflineBrowseApi()
      : SupabaseBrowseApi(supabase) as BrowseApi;
  final covers = CoverCache(db: db, api: browseApi);
  sl
    ..registerSingleton<RecipeDetailRepository>(
      RecipeDetailRepositoryImpl(
        db: db,
        outbox: outbox,
        remote: remote,
        sync: sync,
        api: browseApi,
        covers: covers,
      ),
    )
    ..registerSingleton<CookRepository>(
      CookRepositoryImpl(db: db, outbox: outbox, sync: sync),
    )
    ..registerSingleton<ScreenAwake>(const WakelockScreenAwake())
    ..registerSingleton<CreateRepository>(
      CreateRepositoryImpl(db: db, outbox: outbox, sync: sync),
    )
    ..registerLazySingleton<PhotoStore>(DevicePhotoStore.new);
  void backfill() {
    final uid = remote.userId;
    if (uid != null) unawaited(covers.backfill(uid));
  }

  sync.reports.listen((_) => backfill());
  db.tableUpdates(TableUpdateQuery.onTable(db.saves)).listen((_) => backfill());
}

RemoteStore _remoteFor(SupabaseClient? client) =>
    client == null ? const OfflineRemoteStore() : SupabaseRemoteStore(client);
