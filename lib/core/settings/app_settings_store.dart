import 'package:shared_plates_app/core/db/app_database.dart';

enum SettingKey { guest, checklistDismissed, friendRequested }

class AppSettingsStore {
  new(this._db);

  final AppDatabase _db;

  Future<bool> flag(SettingKey key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(key.name))).getSingleOrNull();
    return row?.value == 'true';
  }

  Stream<bool> watchFlag(SettingKey key) =>
      (_db.select(_db.appSettings)..where((t) => t.key.equals(key.name)))
          .watchSingleOrNull()
          .map((row) => row?.value == 'true');

  Future<void> setFlag(SettingKey key, {required bool value}) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: key.name, value: '$value'),
      );
}
