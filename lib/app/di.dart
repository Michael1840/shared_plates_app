import 'package:get_it/get_it.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/sync/connectivity_service.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/remote_store.dart';
import 'package:shared_plates_app/core/sync/supabase_remote_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

void configureDependencies({required SupabaseClient? supabase}) {
  final db = AppDatabase.open();
  final connectivity = ConnectivityService();
  final outbox = OutboxStore(db);
  sl
    ..registerSingleton<AppDatabase>(db, dispose: (d) => d.close())
    ..registerSingleton<ConnectivityService>(connectivity)
    ..registerSingleton<OutboxStore>(outbox);
  if (supabase == null) return;
  final remote = SupabaseRemoteStore(supabase);
  sl
    ..registerSingleton<SupabaseClient>(supabase)
    ..registerSingleton<RemoteStore>(remote)
    ..registerSingleton<SyncService>(
      SyncService(
        db: db,
        outbox: outbox,
        remote: remote,
        online: connectivity.onlineChanges,
      ),
      dispose: (s) => s.dispose(),
    );
}
