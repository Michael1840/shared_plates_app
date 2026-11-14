import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/db/mappers.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/measure.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';
import 'package:shared_plates_app/core/sync/outbox_store.dart';
import 'package:shared_plates_app/core/sync/sync_service.dart';
import 'package:shared_plates_app/core/utils/error_reporter.dart';
import 'package:shared_plates_app/core/utils/result.dart';
import 'package:shared_plates_app/features/create/domain/food_matcher.dart';
import 'package:shared_plates_app/features/create/domain/recipe_draft.dart';
import 'package:shared_plates_app/features/create/domain/recipe_parser.dart';

class DraftSummary extends Equatable {
  const new({
    required this.card,
    required this.ingredientCount,
    required this.stepCount,
  });

  final RecipeCard card;
  final int ingredientCount;
  final int stepCount;

  int get stepsToGo => [
    card.title.trim().isEmpty,
    ingredientCount == 0,
    stepCount == 0,
  ].where((missing) => missing).length;

  @override
  List<Object?> get props => [card, ingredientCount, stepCount];
}

abstract final class CreateMessages {
  static const saveFailed = "Couldn't save that on your phone. Try again.";
}

abstract interface class CreateRepository {
  Future<FoodLibrary> library();

  Future<List<Tag>> tags();

  Stream<List<DraftSummary>> watchDrafts(String uid);

  Future<RecipeDraft?> load(String id);

  Future<Result<void>> save(
    String uid,
    RecipeDraft draft,
    FoodLibrary library, {
    bool push = false,
  });

  Future<void> discard(String id);

  Future<int> publishedCount(String uid);

  Future<List<RecipeCard>> savedRecipes(String uid);

  Future<RecipeCard?> card(String id, String uid);
}

class CreateRepositoryImpl implements CreateRepository {
  new({
    required this._db,
    required this._outbox,
    required this._sync,
    DateTime Function()? clock,
  }) : _now = clock ?? DateTime.now;

  static const _maxRaw = 200;
  static const _maxPrep = 80;
  static const _maxSection = 60;
  static const _maxBody = 2000;
  static const _maxNote = 280;

  final AppDatabase _db;
  final OutboxStore _outbox;
  final SyncService _sync;
  final DateTime Function() _now;

  @override
  Future<FoodLibrary> library() async {
    final foods = await _db.select(_db.foods).get();
    final portions = await _db.select(_db.foodPortions).get();
    final units = await _db.select(_db.measureUnits).get();
    return FoodLibrary(
      foods: [
        for (final f in foods)
          Food(
            id: f.id,
            name: f.name,
            aliases: f.aliases,
            category: f.category,
            kcal100g: f.kcal100g,
            protein100g: f.protein100g,
            carbs100g: f.carbs100g,
            fat100g: f.fat100g,
            fibre100g: f.fibre100g,
            densityGMl: f.densityGMl,
            updatedAt: f.updatedAt,
          ),
      ],
      portions: [
        for (final p in portions)
          FoodPortion(
            foodId: p.foodId,
            label: p.label,
            grams: p.grams,
            isDefault: p.isDefault,
            updatedAt: p.updatedAt,
          ),
      ],
      units: {
        ...Measure.defaults,
        for (final u in units)
          u.code: UnitDef(u.code, u.kind, u.scope, u.toBase),
      },
    );
  }

  @override
  Future<List<Tag>> tags() async {
    final rows = await (_db.select(
      _db.tags,
    )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    return [for (final r in rows) r.toDomain()];
  }

  @override
  Stream<List<DraftSummary>> watchDrafts(String uid) {
    final query = _db.select(_db.recipes)
      ..where(
        (t) =>
            t.authorId.equals(uid) &
            t.status.equalsValue(RecipeStatus.draft) &
            t.deletedAt.isNull(),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch().asyncMap((rows) async {
      final ids = [for (final r in rows) r.id];
      final ingredients = await _countBy(_db.recipeIngredients, ids);
      final steps = await _countBy(_db.recipeSteps, ids);
      return [
        for (final r in rows)
          DraftSummary(
            card: r.toCard(viewerId: uid),
            ingredientCount: ingredients[r.id] ?? 0,
            stepCount: steps[r.id] ?? 0,
          ),
      ];
    });
  }

  Future<Map<String, int>> _countBy(
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

  @override
  Future<RecipeDraft?> load(String id) async {
    final row = await (_db.select(
      _db.recipes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null || row.deletedAt != null) return null;
    final ingredients =
        await (_db.select(_db.recipeIngredients)
              ..where((t) => t.recipeId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final steps =
        await (_db.select(_db.recipeSteps)
              ..where((t) => t.recipeId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final tags = await (_db.select(
      _db.recipeTags,
    )..where((t) => t.recipeId.equals(id))).get();
    return RecipeDraft(
      id: row.id,
      title: row.title,
      note: row.note,
      servings: row.baseServings,
      totalMinutes: row.totalMinutes,
      coverStyle: row.coverStyle,
      coverPath: row.coverPath,
      localCoverPath: row.localCoverPath,
      visibility: row.visibility,
      status: row.status,
      source: row.source,
      sourceText: row.sourceText,
      forkedFromId: row.forkedFromId,
      createdAt: row.createdAt,
      publishedAt: row.publishedAt,
      tagIds: {for (final t in tags) t.tagId},
      ingredients: [
        for (final i in ingredients)
          DraftIngredient(
            id: i.id,
            rawText: i.rawText,
            name: RecipeParser.parseIngredient(i.rawText).name,
            quantity: i.quantity,
            unit: i.unit,
            portionLabel: i.portionLabel,
            prepNote: i.prepNote,
            section: i.section,
            foodId: i.foodId,
            costCents: i.costCents,
            optional: i.optional,
          ),
      ],
      steps: [for (final s in steps) DraftStep(id: s.id, body: s.body)],
    );
  }

  static String _coverPath(String uid, String id, String local) {
    final name = local.split(RegExp(r'[\\/]')).last.split('.').first;
    return '$uid/$id/cover-$name.jpg';
  }

  static String _clip(String text, int max) =>
      text.length <= max ? text : text.substring(0, max);

  static String? _clipOrNull(String? text, int max) {
    final t = text?.trim();
    return t == null || t.isEmpty ? null : _clip(t, max);
  }

  @override
  Future<Result<void>> save(
    String uid,
    RecipeDraft draft,
    FoodLibrary library, {
    bool push = false,
  }) async {
    final now = _now().toUtc();
    final id = draft.id;
    final created = draft.createdAt ?? now;
    final published = draft.isPublished ? draft.publishedAt ?? now : null;
    final title = _clip(draft.title.trim(), RecipeDraft.maxTitle);
    final note = _clipOrNull(draft.note, _maxNote);
    final servings = draft.servings.clamp(
      RecipeDraft.minServings,
      RecipeDraft.maxServings,
    );
    final minutes = draft.totalMinutes;
    final totalMinutes =
        minutes == null || minutes < 1 || minutes > RecipeDraft.maxMinutes
        ? null
        : minutes;
    final nutrition = NutritionTotals.of(draft, library);
    final steps = draft.filledSteps;
    final links = draft.linksFor(library);
    final ingredientRows = [
      for (final (i, ing) in draft.ingredients.indexed)
        {
          'id': ing.id,
          'recipe_id': id,
          'position': i,
          'section': _clipOrNull(ing.section, _maxSection),
          'raw_text': _clip(ing.rawText.trim(), _maxRaw),
          'quantity': ing.quantity,
          'unit': ing.unit,
          'portion_label': ing.portionLabel,
          'food_id': ing.foodId,
          'prep_note': _clipOrNull(ing.prepNote, _maxPrep),
          'cost_cents': ing.costCents,
          'optional': ing.optional,
        },
    ];
    final stepRows = [
      for (final (i, step) in steps.indexed)
        {
          'id': step.id,
          'recipe_id': id,
          'position': i,
          'body': _clip(step.body.trim(), _maxBody),
          'timer_seconds': step.timerSeconds,
        },
    ];
    final linkRows = [
      for (final (i, step) in steps.indexed)
        for (final ingredientId in links[i])
          {'step_id': step.id, 'ingredient_id': ingredientId},
    ];
    final local = draft.localCoverPath;
    final needsUpload = local != null && draft.coverPath == null;
    final snapshot = <String, Object?>{
      'recipe': {
        'id': id,
        'title': title,
        'forked_from_id': draft.forkedFromId,
        'note': note,
        'cover_path': draft.coverPath,
        'cover_style': draft.coverStyle.name,
        'base_servings': servings,
        'total_minutes': totalMinutes,
        'visibility': draft.visibility.name,
        'status': draft.status.name,
        'source': draft.source.name,
        'source_text': draft.sourceText,
      },
      'ingredients': ingredientRows,
      'steps': stepRows,
      'links': linkRows,
      'tags': draft.tagIds.toList(),
      'cover': needsUpload
          ? {'local': local, 'path': _coverPath(uid, id, local)}
          : null,
    };
    try {
      await _db.transaction(() async {
        await _db
            .into(_db.recipes)
            .insertOnConflictUpdate(
              RecipesCompanion.insert(
                id: id,
                authorId: uid,
                forkedFromId: Value(draft.forkedFromId),
                title: Value(title),
                note: Value(note),
                coverPath: Value(draft.coverPath),
                localCoverPath: Value(local),
                coverStyle: draft.coverStyle,
                baseServings: Value(servings),
                totalMinutes: Value(totalMinutes),
                visibility: draft.visibility,
                status: draft.status,
                source: draft.source,
                sourceText: Value(draft.sourceText),
                kcalPerServing: Value(
                  nutrition.matched == 0 ? null : nutrition.kcal,
                ),
                proteinG: Value(
                  nutrition.matched == 0 ? null : nutrition.protein,
                ),
                carbsG: Value(nutrition.matched == 0 ? null : nutrition.carbs),
                fatG: Value(nutrition.matched == 0 ? null : nutrition.fat),
                fibreG: Value(nutrition.matched == 0 ? null : nutrition.fibre),
                ingredientCount: Value(draft.ingredients.length),
                matchedLines: Value(nutrition.matched),
                costCents: Value(draft.costCents),
                publishedAt: Value(published),
                createdAt: created,
                updatedAt: now,
              ),
            );
        await (_db.delete(
          _db.recipeIngredients,
        )..where((t) => t.recipeId.equals(id))).go();
        await (_db.delete(
          _db.recipeSteps,
        )..where((t) => t.recipeId.equals(id))).go();
        await (_db.delete(
          _db.stepIngredients,
        )..where((t) => t.recipeId.equals(id))).go();
        await (_db.delete(
          _db.recipeTags,
        )..where((t) => t.recipeId.equals(id))).go();
        await _db.batch((b) {
          b
            ..insertAll(_db.recipeIngredients, [
              for (final r in ingredientRows)
                RecipeIngredientsCompanion.insert(
                  id: r['id']! as String,
                  recipeId: id,
                  position: r['position']! as int,
                  section: Value(r['section'] as String?),
                  rawText: r['raw_text']! as String,
                  quantity: Value(r['quantity'] as double?),
                  unit: Value(r['unit'] as String?),
                  portionLabel: Value(r['portion_label'] as String?),
                  foodId: Value(r['food_id'] as String?),
                  prepNote: Value(r['prep_note'] as String?),
                  grams: Value(
                    library.gramsFor(
                      foodId: r['food_id'] as String?,
                      quantity: r['quantity'] as double?,
                      unit: r['unit'] as String?,
                      portion: r['portion_label'] as String?,
                    ),
                  ),
                  costCents: Value(r['cost_cents'] as int?),
                  optional: Value(r['optional']! as bool),
                  updatedAt: now,
                ),
            ])
            ..insertAll(_db.recipeSteps, [
              for (final r in stepRows)
                RecipeStepsCompanion.insert(
                  id: r['id']! as String,
                  recipeId: id,
                  position: r['position']! as int,
                  body: r['body']! as String,
                  timerSeconds: Value(r['timer_seconds'] as int?),
                  updatedAt: now,
                ),
            ])
            ..insertAll(_db.stepIngredients, [
              for (final r in linkRows)
                StepIngredientsCompanion.insert(
                  stepId: r['step_id']!,
                  ingredientId: r['ingredient_id']!,
                  recipeId: id,
                ),
            ])
            ..insertAll(_db.recipeTags, [
              for (final t in draft.tagIds)
                RecipeTagsCompanion.insert(recipeId: id, tagId: t),
            ]);
        });
        await _outbox.enqueue(OutboxOperation.recipe(id, snapshot));
      });
      if (push) _sync.requestSync();
      return const Result.ok(null);
    } on Exception catch (e, s) {
      ErrorReporter.report('CreateRepository.save', e, s);
      return Result.error(Exception(CreateMessages.saveFailed));
    }
  }

  @override
  Future<void> discard(String id) async {
    await _outbox.discardPending('recipes:$id');
    await _db.transaction(() async {
      await (_db.delete(_db.recipes)..where((t) => t.id.equals(id))).go();
      await (_db.delete(
        _db.recipeIngredients,
      )..where((t) => t.recipeId.equals(id))).go();
      await (_db.delete(
        _db.recipeSteps,
      )..where((t) => t.recipeId.equals(id))).go();
      await (_db.delete(
        _db.stepIngredients,
      )..where((t) => t.recipeId.equals(id))).go();
      await (_db.delete(
        _db.recipeTags,
      )..where((t) => t.recipeId.equals(id))).go();
      await _outbox.enqueue(
        OutboxOperation.delete('recipes', {
          'id': id,
        }, dedupeKey: 'recipes-delete:$id'),
      );
    });
    _sync.requestSync();
  }

  @override
  Future<int> publishedCount(String uid) async {
    final count = _db.recipes.id.count();
    final query = _db.selectOnly(_db.recipes)
      ..addColumns([count])
      ..where(
        _db.recipes.authorId.equals(uid) &
            _db.recipes.status.equalsValue(RecipeStatus.published) &
            _db.recipes.deletedAt.isNull(),
      );
    final row = await query.getSingle();
    final total = row.read(count);
    return total ?? 0;
  }

  @override
  Future<List<RecipeCard>> savedRecipes(String uid) async {
    final rows =
        await (_db.select(_db.recipes).join([
                innerJoin(
                  _db.saves,
                  _db.saves.recipeId.equalsExp(_db.recipes.id) &
                      _db.saves.userId.equals(uid),
                ),
              ])
              ..where(_db.recipes.deletedAt.isNull())
              ..orderBy([OrderingTerm.desc(_db.saves.createdAt)]))
            .get();
    return [
      for (final r in rows) r.readTable(_db.recipes).toCard(viewerId: uid),
    ];
  }

  @override
  Future<RecipeCard?> card(String id, String uid) async {
    final row = await (_db.select(
      _db.recipes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row?.toCard(viewerId: uid);
  }
}
