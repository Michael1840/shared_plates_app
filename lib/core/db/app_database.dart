import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:shared_plates_app/core/db/tables.dart';
import 'package:shared_plates_app/core/domain/enums.dart';

export 'package:shared_plates_app/core/db/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Tags,
    MeasureUnits,
    Foods,
    FoodPortions,
    Profiles,
    ProfileTastes,
    Recipes,
    RecipeIngredients,
    RecipeSteps,
    StepIngredients,
    RecipeTags,
    Likes,
    Saves,
    Cooks,
    ShoppingTicks,
    RecentlyViewed,
    Outbox,
    SyncCursors,
  ],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  factory open() => AppDatabase(driftDatabase(name: 'shared_plates'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX ingredients_recipe ON recipe_ingredients '
        '(recipe_id, position)',
      );
      await customStatement(
        'CREATE INDEX steps_recipe ON recipe_steps (recipe_id, position)',
      );
      await customStatement(
        'CREATE INDEX outbox_pending ON outbox (failed, next_attempt_at, id)',
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = OFF');
    },
  );

  Future<DateTime?> cursorFor(String scope) async {
    final row = await (select(
      syncCursors,
    )..where((t) => t.scope.equals(scope))).getSingleOrNull();
    return row?.cursor;
  }

  Future<void> setCursor(String scope, DateTime cursor) => into(syncCursors)
      .insertOnConflictUpdate(
        SyncCursorsCompanion.insert(scope: scope, cursor: cursor),
      );

  Future<void> clearUserData() => transaction(() async {
    for (final table in <TableInfo<Table, Object?>>[
      profiles,
      profileTastes,
      recipes,
      recipeIngredients,
      recipeSteps,
      stepIngredients,
      recipeTags,
      likes,
      saves,
      cooks,
      shoppingTicks,
      recentlyViewed,
      outbox,
    ]) {
      await delete(table).go();
    }
    await (delete(syncCursors)..where((t) => t.scope.like('user:%'))).go();
  });
}
