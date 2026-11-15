import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/db/reload_on.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';

class LibraryEntry extends Equatable {
  const LibraryEntry({
    required this.card,
    required this.addedAt,
    this.isMine = false,
    this.isSaved = false,
    this.tagIds = const {},
    this.ingredientCount = 0,
    this.stepCount = 0,
  });

  final RecipeCard card;
  final DateTime addedAt;
  final bool isMine;
  final bool isSaved;
  final Set<int> tagIds;
  final int ingredientCount;
  final int stepCount;

  bool get isDraft => isMine && card.status == RecipeStatus.draft;

  int get stepsToGo => [
    card.title.trim().isEmpty,
    ingredientCount == 0,
    stepCount == 0,
  ].where((missing) => missing).length;

  @override
  List<Object?> get props => [
    card,
    addedAt,
    isMine,
    isSaved,
    tagIds,
    ingredientCount,
    stepCount,
  ];
}

abstract interface class LibraryRepository {
  Stream<List<LibraryEntry>> watch(String uid);
}

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<LibraryEntry>> watch(String uid) => reloadOn(
    _db.tableUpdates(
      TableUpdateQuery.onAllTables([
        _db.recipes,
        _db.saves,
        _db.recipeTags,
        _db.recipeIngredients,
        _db.recipeSteps,
      ]),
    ),
    () => _load(uid),
  );

  Future<List<LibraryEntry>> _load(String uid) async {
    final saved = _db.selectOnly(_db.saves)
      ..addColumns([_db.saves.recipeId])
      ..where(_db.saves.userId.equals(uid));
    final rows =
        await (_db.select(_db.recipes)..where(
              (r) =>
                  r.deletedAt.isNull() &
                  (r.authorId.equals(uid) | r.id.isInQuery(saved)),
            ))
            .get();
    final ids = [for (final r in rows) r.id];
    final saves = {
      for (final s in await (_db.select(
        _db.saves,
      )..where((t) => t.userId.equals(uid))).get())
        s.recipeId: s.createdAt,
    };
    final tags = <String, Set<int>>{};
    if (ids.isNotEmpty) {
      for (final t in await (_db.select(
        _db.recipeTags,
      )..where((t) => t.recipeId.isIn(ids))).get()) {
        tags.putIfAbsent(t.recipeId, () => {}).add(t.tagId);
      }
    }
    final ingredients = await _count(_db.recipeIngredients, ids);
    final steps = await _count(_db.recipeSteps, ids);
    return [
      for (final r in rows)
        LibraryEntry(
          card: r.toCard(viewerId: uid),
          addedAt: r.authorId == uid ? r.updatedAt : saves[r.id] ?? r.updatedAt,
          isMine: r.authorId == uid,
          isSaved: saves.containsKey(r.id),
          tagIds: tags[r.id] ?? const {},
          ingredientCount: ingredients[r.id] ?? 0,
          stepCount: steps[r.id] ?? 0,
        ),
    ];
  }

  Future<Map<String, int>> _count(
    TableInfo<Table, Object?> table,
    List<String> ids,
  ) async {
    if (ids.isEmpty) return const {};
    final rows = await _db
        .customSelect(
          'SELECT recipe_id, COUNT(*) AS n FROM ${table.actualTableName} '
          'WHERE recipe_id IN (${List.filled(ids.length, '?').join(',')}) '
          'GROUP BY recipe_id',
          variables: [for (final id in ids) Variable.withString(id)],
          readsFrom: {table},
        )
        .get();
    return {
      for (final r in rows) r.read<String>('recipe_id'): r.read<int>('n'),
    };
  }
}
