import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/domain/enums.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const new();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<dynamic>).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

@DataClassName('TagRow')
class Tags extends Table {
  IntColumn get id => integer()();
  TextColumn get slug => text()();
  TextColumn get label => text()();
  TextColumn get kind => textEnum<TagKind>()();
  TextColumn get coverStyle => textEnum<CoverStyle>()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('UnitRow')
class MeasureUnits extends Table {
  TextColumn get code => text()();
  TextColumn get label => text()();
  TextColumn get kind => textEnum<UnitKind>()();
  TextColumn get scope => textEnum<UnitScope>()();
  RealColumn get toBase => real()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

@DataClassName('FoodRow')
class Foods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get aliases => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get category => text().nullable()();
  RealColumn get kcal100g => real().withDefault(const Constant(0))();
  RealColumn get protein100g => real().withDefault(const Constant(0))();
  RealColumn get carbs100g => real().withDefault(const Constant(0))();
  RealColumn get fat100g => real().withDefault(const Constant(0))();
  RealColumn get fibre100g => real().withDefault(const Constant(0))();
  RealColumn get sugar100g => real().nullable()();
  RealColumn get sodiumMg100g => real().nullable()();
  RealColumn get densityGMl => real().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FoodPortionRow')
class FoodPortions extends Table {
  TextColumn get foodId => text()();
  TextColumn get label => text()();
  RealColumn get grams => real()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {foodId, label};
}

@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get displayName => text()();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get units => textEnum<UnitSystem>()();
  TextColumn get currency => text().withDefault(const Constant('ZAR'))();
  TextColumn get defaultVisibility => textEnum<RecipeVisibility>()();
  BoolColumn get keepScreenOn => boolean().withDefault(const Constant(true))();
  BoolColumn get notifySaves => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyCooks => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyFriends => boolean().withDefault(const Constant(true))();
  BoolColumn get weeklyRoundup => boolean().withDefault(const Constant(true))();
  DateTimeColumn get onboardedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProfileTasteRow')
class ProfileTastes extends Table {
  TextColumn get userId => text()();
  IntColumn get tagId => integer()();

  @override
  Set<Column<Object>> get primaryKey => {userId, tagId};
}

@DataClassName('HiddenFoodRow')
class HiddenFoods extends Table {
  TextColumn get userId => text()();
  TextColumn get foodId => text()();

  @override
  Set<Column<Object>> get primaryKey => {userId, foodId};
}

@DataClassName('AppSettingRow')
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('RecipeRow')
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text()();
  TextColumn get forkedFromId => text().nullable()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get note => text().nullable()();
  TextColumn get coverPath => text().nullable()();
  TextColumn get localCoverPath => text().nullable()();
  TextColumn get coverStyle => textEnum<CoverStyle>()();
  IntColumn get baseServings => integer().withDefault(const Constant(4))();
  IntColumn get totalMinutes => integer().nullable()();
  TextColumn get visibility => textEnum<RecipeVisibility>()();
  TextColumn get status => textEnum<RecipeStatus>()();
  TextColumn get source => textEnum<RecipeSource>()();
  TextColumn get sourceText => text().nullable()();
  RealColumn get kcalPerServing => real().nullable()();
  RealColumn get proteinG => real().nullable()();
  RealColumn get carbsG => real().nullable()();
  RealColumn get fatG => real().nullable()();
  RealColumn get fibreG => real().nullable()();
  IntColumn get ingredientCount => integer().withDefault(const Constant(0))();
  IntColumn get matchedLines => integer().withDefault(const Constant(0))();
  IntColumn get costCents => integer().nullable()();
  TextColumn get costCurrency => text().withDefault(const Constant('ZAR'))();
  IntColumn get likeCount => integer().withDefault(const Constant(0))();
  IntColumn get saveCount => integer().withDefault(const Constant(0))();
  IntColumn get cookCount => integer().withDefault(const Constant(0))();
  TextColumn get authorName => text().nullable()();
  TextColumn get authorUsername => text().nullable()();
  TextColumn get authorAvatar => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('IngredientRow')
class RecipeIngredients extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text()();
  IntColumn get position => integer()();
  TextColumn get section => text().nullable()();
  TextColumn get rawText => text()();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get portionLabel => text().nullable()();
  TextColumn get foodId => text().nullable()();
  TextColumn get prepNote => text().nullable()();
  RealColumn get grams => real().nullable()();
  IntColumn get costCents => integer().nullable()();
  BoolColumn get optional => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('StepRow')
class RecipeSteps extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text()();
  IntColumn get position => integer()();
  TextColumn get body => text()();
  IntColumn get timerSeconds => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('StepIngredientRow')
class StepIngredients extends Table {
  TextColumn get stepId => text()();
  TextColumn get ingredientId => text()();
  TextColumn get recipeId => text()();

  @override
  Set<Column<Object>> get primaryKey => {stepId, ingredientId};
}

@DataClassName('RecipeTagRow')
class RecipeTags extends Table {
  TextColumn get recipeId => text()();
  IntColumn get tagId => integer()();

  @override
  Set<Column<Object>> get primaryKey => {recipeId, tagId};
}

@DataClassName('LikeRow')
class Likes extends Table {
  TextColumn get userId => text()();
  TextColumn get recipeId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId, recipeId};
}

@DataClassName('SaveRow')
class Saves extends Table {
  TextColumn get userId => text()();
  TextColumn get recipeId => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId, recipeId};
}

@DataClassName('CookRow')
class Cooks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get recipeId => text()();
  IntColumn get servings => integer().nullable()();
  BoolColumn get toldCreator => boolean().withDefault(const Constant(false))();
  DateTimeColumn get cookedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShoppingTickRow')
class ShoppingTicks extends Table {
  TextColumn get userId => text()();
  TextColumn get ingredientId => text()();
  TextColumn get recipeId => text()();
  DateTimeColumn get tickedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId, ingredientId};
}

@DataClassName('RecentlyViewedRow')
class RecentlyViewed extends Table {
  TextColumn get userId => text()();
  TextColumn get recipeId => text()();
  DateTimeColumn get viewedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId, recipeId};
}

enum OutboxKind { upsert, update, delete, rpc }

@DataClassName('OutboxEntry')
class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<OutboxKind>()();
  TextColumn get target => text()();
  TextColumn get payload => text()();
  TextColumn get onConflict => text().nullable()();
  TextColumn get dedupeKey => text().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  BoolColumn get failed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
}

@DataClassName('SyncCursorRow')
class SyncCursors extends Table {
  TextColumn get scope => text()();
  DateTimeColumn get cursor => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {scope};
}
