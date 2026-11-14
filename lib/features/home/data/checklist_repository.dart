import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/settings/app_settings_store.dart';

class ChecklistProgress extends Equatable {
  const new({
    this.setUp = false,
    this.saved = false,
    this.shared = false,
    this.friendAdded = false,
    this.dismissed = false,
  });

  final bool setUp;
  final bool saved;
  final bool shared;
  final bool friendAdded;
  final bool dismissed;

  int get done => [setUp, saved, shared, friendAdded].where((d) => d).length;

  static const total = 4;

  bool get complete => done == total;

  @override
  List<Object?> get props => [setUp, saved, shared, friendAdded, dismissed];
}

abstract interface class ChecklistRepository {
  Stream<ChecklistProgress> watch(String uid);

  Future<void> dismiss();
}

class ChecklistRepositoryImpl implements ChecklistRepository {
  new(this._db, this._settings);

  final AppDatabase _db;
  final AppSettingsStore _settings;

  @override
  Stream<ChecklistProgress> watch(String uid) {
    final user = Variable.withString(uid);
    return _db
        .customSelect(
          'SELECT '
          '(SELECT onboarded_at IS NOT NULL FROM profiles WHERE id = ?) '
          'AS set_up, '
          '(SELECT COUNT(*) FROM saves WHERE user_id = ?) AS saved, '
          '(SELECT COUNT(*) FROM recipes WHERE author_id = ? '
          "AND status = 'published' AND deleted_at IS NULL) AS shared, "
          '(SELECT value FROM app_settings WHERE key = ?) AS friend, '
          '(SELECT value FROM app_settings WHERE key = ?) AS dismissed',
          variables: [
            user,
            user,
            user,
            Variable.withString(SettingKey.friendRequested.name),
            Variable.withString(SettingKey.checklistDismissed.name),
          ],
          readsFrom: {_db.profiles, _db.saves, _db.recipes, _db.appSettings},
        )
        .watchSingle()
        .map(
          (row) => ChecklistProgress(
            setUp: (row.readNullable<int>('set_up') ?? 0) == 1,
            saved: row.read<int>('saved') > 0,
            shared: row.read<int>('shared') > 0,
            friendAdded: row.readNullable<String>('friend') == 'true',
            dismissed: row.readNullable<String>('dismissed') == 'true',
          ),
        );
  }

  @override
  Future<void> dismiss() =>
      _settings.setFlag(SettingKey.checklistDismissed, value: true);
}
