import 'package:drift/drift.dart';
import 'package:shared_plates_app/core/db/app_database.dart';
import 'package:shared_plates_app/core/domain/enums.dart';
import 'package:shared_plates_app/core/domain/models/profile.dart';
import 'package:shared_plates_app/core/domain/models/recipe.dart';
import 'package:shared_plates_app/core/domain/models/reference.dart';

extension TagRowMapping on Tag {
  TagsCompanion toCompanion() => TagsCompanion.insert(
    id: Value(id),
    slug: slug,
    label: label,
    kind: kind,
    coverStyle: coverStyle,
    position: Value(position),
    updatedAt: updatedAt,
  );
}

extension UnitRowMapping on MeasureUnit {
  MeasureUnitsCompanion toCompanion() => MeasureUnitsCompanion.insert(
    code: code,
    label: label,
    kind: kind,
    scope: scope,
    toBase: toBase,
    updatedAt: updatedAt,
  );
}

extension FoodRowMapping on Food {
  FoodsCompanion toCompanion() => FoodsCompanion.insert(
    id: id,
    name: name,
    aliases: Value(aliases),
    category: Value(category),
    kcal100g: Value(kcal100g),
    protein100g: Value(protein100g),
    carbs100g: Value(carbs100g),
    fat100g: Value(fat100g),
    fibre100g: Value(fibre100g),
    sugar100g: Value(sugar100g),
    sodiumMg100g: Value(sodiumMg100g),
    densityGMl: Value(densityGMl),
    updatedAt: updatedAt,
  );
}

extension FoodPortionRowMapping on FoodPortion {
  FoodPortionsCompanion toCompanion() => FoodPortionsCompanion.insert(
    foodId: foodId,
    label: label,
    grams: grams,
    isDefault: Value(isDefault),
    updatedAt: updatedAt,
  );
}

extension ProfileRowMapping on Profile {
  ProfilesCompanion toCompanion() => ProfilesCompanion.insert(
    id: id,
    username: username,
    displayName: displayName,
    avatarPath: Value(avatarPath),
    bio: Value(bio),
    city: Value(city),
    units: units,
    currency: Value(currency),
    defaultVisibility: defaultVisibility,
    keepScreenOn: Value(keepScreenOn),
    notifySaves: Value(notifySaves),
    notifyCooks: Value(notifyCooks),
    notifyFriends: Value(notifyFriends),
    weeklyRoundup: Value(weeklyRoundup),
    onboardedAt: Value(onboardedAt),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension RecipeRowMapping on Recipe {
  RecipesCompanion toCompanion() => RecipesCompanion.insert(
    id: id,
    authorId: authorId,
    forkedFromId: Value(forkedFromId),
    title: Value(title),
    note: Value(note),
    coverPath: Value(coverPath),
    coverStyle: coverStyle,
    baseServings: Value(baseServings),
    totalMinutes: Value(totalMinutes),
    visibility: visibility,
    status: status,
    source: source,
    sourceText: Value(sourceText),
    kcalPerServing: Value(kcalPerServing),
    proteinG: Value(proteinG),
    carbsG: Value(carbsG),
    fatG: Value(fatG),
    fibreG: Value(fibreG),
    ingredientCount: Value(ingredientCount),
    matchedLines: Value(matchedLines),
    costCents: Value(costCents),
    costCurrency: Value(costCurrency),
    likeCount: Value(likeCount),
    saveCount: Value(saveCount),
    cookCount: Value(cookCount),
    publishedAt: Value(publishedAt),
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: Value(deletedAt),
  );
}

extension RecipeCardRowMapping on RecipeCard {
  RecipesCompanion toCompanion() => RecipesCompanion.insert(
    id: id,
    authorId: authorId,
    forkedFromId: Value(forkedFromId),
    title: Value(title),
    note: Value(note),
    coverPath: Value(coverPath),
    coverStyle: coverStyle,
    baseServings: Value(baseServings),
    totalMinutes: Value(totalMinutes),
    visibility: visibility,
    status: status,
    source: RecipeSource.typed,
    kcalPerServing: Value(kcalPerServing),
    proteinG: Value(proteinG),
    carbsG: Value(carbsG),
    fatG: Value(fatG),
    fibreG: Value(fibreG),
    ingredientCount: Value(ingredientCount),
    matchedLines: Value(matchedLines),
    costCents: Value(costCents),
    costCurrency: Value(costCurrency),
    likeCount: Value(likeCount),
    saveCount: Value(saveCount),
    cookCount: Value(cookCount),
    authorName: Value(authorName),
    authorUsername: Value(authorUsername),
    authorAvatar: Value(authorAvatar),
    publishedAt: Value(publishedAt),
    createdAt: publishedAt ?? updatedAt,
    updatedAt: updatedAt,
  );
}

extension IngredientRowMapping on RecipeIngredient {
  RecipeIngredientsCompanion toCompanion() => RecipeIngredientsCompanion.insert(
    id: id,
    recipeId: recipeId,
    position: position,
    section: Value(section),
    rawText: rawText,
    quantity: Value(quantity),
    unit: Value(unit),
    portionLabel: Value(portionLabel),
    foodId: Value(foodId),
    prepNote: Value(prepNote),
    grams: Value(grams),
    costCents: Value(costCents),
    optional: Value(optional),
    updatedAt: updatedAt,
  );
}

extension StepRowMapping on RecipeStep {
  RecipeStepsCompanion toCompanion() => RecipeStepsCompanion.insert(
    id: id,
    recipeId: recipeId,
    position: position,
    body: body,
    timerSeconds: Value(timerSeconds),
    updatedAt: updatedAt,
  );
}

extension ProfileRowToDomain on ProfileRow {
  Profile toDomain() => Profile(
    id: id,
    username: username,
    displayName: displayName,
    avatarPath: avatarPath,
    bio: bio,
    city: city,
    units: units,
    currency: currency,
    defaultVisibility: defaultVisibility,
    keepScreenOn: keepScreenOn,
    notifySaves: notifySaves,
    notifyCooks: notifyCooks,
    notifyFriends: notifyFriends,
    weeklyRoundup: weeklyRoundup,
    onboardedAt: onboardedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension TagRowToDomain on TagRow {
  Tag toDomain() => Tag(
    id: id,
    slug: slug,
    label: label,
    kind: kind,
    coverStyle: coverStyle,
    position: position,
    updatedAt: updatedAt,
  );
}
