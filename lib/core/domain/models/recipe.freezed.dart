// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Recipe {

 String get id; String get authorId; DateTime get createdAt; DateTime get updatedAt; String get title; String? get forkedFromId; String? get note; String? get coverPath; CoverStyle get coverStyle; int get baseServings; int? get totalMinutes; RecipeVisibility get visibility; RecipeStatus get status; RecipeSource get source; String? get sourceText; double? get kcalPerServing; double? get proteinG; double? get carbsG; double? get fatG; double? get fibreG; int get ingredientCount; int get matchedLines; int? get costCents; String get costCurrency; int get likeCount; int get saveCount; int get cookCount; DateTime? get publishedAt; DateTime? get deletedAt;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Recipe;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.authorId, _this.authorId) || other.authorId == _this.authorId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.forkedFromId, _this.forkedFromId) || other.forkedFromId == _this.forkedFromId)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.coverPath, _this.coverPath) || other.coverPath == _this.coverPath)&&(identical(other.coverStyle, _this.coverStyle) || other.coverStyle == _this.coverStyle)&&(identical(other.baseServings, _this.baseServings) || other.baseServings == _this.baseServings)&&(identical(other.totalMinutes, _this.totalMinutes) || other.totalMinutes == _this.totalMinutes)&&(identical(other.visibility, _this.visibility) || other.visibility == _this.visibility)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceText, _this.sourceText) || other.sourceText == _this.sourceText)&&(identical(other.kcalPerServing, _this.kcalPerServing) || other.kcalPerServing == _this.kcalPerServing)&&(identical(other.proteinG, _this.proteinG) || other.proteinG == _this.proteinG)&&(identical(other.carbsG, _this.carbsG) || other.carbsG == _this.carbsG)&&(identical(other.fatG, _this.fatG) || other.fatG == _this.fatG)&&(identical(other.fibreG, _this.fibreG) || other.fibreG == _this.fibreG)&&(identical(other.ingredientCount, _this.ingredientCount) || other.ingredientCount == _this.ingredientCount)&&(identical(other.matchedLines, _this.matchedLines) || other.matchedLines == _this.matchedLines)&&(identical(other.costCents, _this.costCents) || other.costCents == _this.costCents)&&(identical(other.costCurrency, _this.costCurrency) || other.costCurrency == _this.costCurrency)&&(identical(other.likeCount, _this.likeCount) || other.likeCount == _this.likeCount)&&(identical(other.saveCount, _this.saveCount) || other.saveCount == _this.saveCount)&&(identical(other.cookCount, _this.cookCount) || other.cookCount == _this.cookCount)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Recipe;
  return Object.hashAll([runtimeType,_this.id,_this.authorId,_this.createdAt,_this.updatedAt,_this.title,_this.forkedFromId,_this.note,_this.coverPath,_this.coverStyle,_this.baseServings,_this.totalMinutes,_this.visibility,_this.status,_this.source,_this.sourceText,_this.kcalPerServing,_this.proteinG,_this.carbsG,_this.fatG,_this.fibreG,_this.ingredientCount,_this.matchedLines,_this.costCents,_this.costCurrency,_this.likeCount,_this.saveCount,_this.cookCount,_this.publishedAt,_this.deletedAt]);
}

@override
String toString() {
  final _this = this as Recipe;
  return 'Recipe(id: ${_this.id}, authorId: ${_this.authorId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, title: ${_this.title}, forkedFromId: ${_this.forkedFromId}, note: ${_this.note}, coverPath: ${_this.coverPath}, coverStyle: ${_this.coverStyle}, baseServings: ${_this.baseServings}, totalMinutes: ${_this.totalMinutes}, visibility: ${_this.visibility}, status: ${_this.status}, source: ${_this.source}, sourceText: ${_this.sourceText}, kcalPerServing: ${_this.kcalPerServing}, proteinG: ${_this.proteinG}, carbsG: ${_this.carbsG}, fatG: ${_this.fatG}, fibreG: ${_this.fibreG}, ingredientCount: ${_this.ingredientCount}, matchedLines: ${_this.matchedLines}, costCents: ${_this.costCents}, costCurrency: ${_this.costCurrency}, likeCount: ${_this.likeCount}, saveCount: ${_this.saveCount}, cookCount: ${_this.cookCount}, publishedAt: ${_this.publishedAt}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, DateTime createdAt, DateTime updatedAt, String title, String? forkedFromId, String? note, String? coverPath, CoverStyle coverStyle, int baseServings, int? totalMinutes, RecipeVisibility visibility, RecipeStatus status, RecipeSource source, String? sourceText, double? kcalPerServing, double? proteinG, double? carbsG, double? fatG, double? fibreG, int ingredientCount, int matchedLines, int? costCents, String costCurrency, int likeCount, int saveCount, int cookCount, DateTime? publishedAt, DateTime? deletedAt
});




}
/// @nodoc
class _$RecipeCopyWithImpl<$Res>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._self, this._then);

  final Recipe _self;
  final $Res Function(Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? createdAt = null,Object? updatedAt = null,Object? title = null,Object? forkedFromId = freezed,Object? note = freezed,Object? coverPath = freezed,Object? coverStyle = null,Object? baseServings = null,Object? totalMinutes = freezed,Object? visibility = null,Object? status = null,Object? source = null,Object? sourceText = freezed,Object? kcalPerServing = freezed,Object? proteinG = freezed,Object? carbsG = freezed,Object? fatG = freezed,Object? fibreG = freezed,Object? ingredientCount = null,Object? matchedLines = null,Object? costCents = freezed,Object? costCurrency = null,Object? likeCount = null,Object? saveCount = null,Object? cookCount = null,Object? publishedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,forkedFromId: freezed == forkedFromId ? _self.forkedFromId : forkedFromId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverStyle: null == coverStyle ? _self.coverStyle : coverStyle // ignore: cast_nullable_to_non_nullable
as CoverStyle,baseServings: null == baseServings ? _self.baseServings : baseServings // ignore: cast_nullable_to_non_nullable
as int,totalMinutes: freezed == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as RecipeVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecipeStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as RecipeSource,sourceText: freezed == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String?,kcalPerServing: freezed == kcalPerServing ? _self.kcalPerServing : kcalPerServing // ignore: cast_nullable_to_non_nullable
as double?,proteinG: freezed == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as double?,carbsG: freezed == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as double?,fatG: freezed == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as double?,fibreG: freezed == fibreG ? _self.fibreG : fibreG // ignore: cast_nullable_to_non_nullable
as double?,ingredientCount: null == ingredientCount ? _self.ingredientCount : ingredientCount // ignore: cast_nullable_to_non_nullable
as int,matchedLines: null == matchedLines ? _self.matchedLines : matchedLines // ignore: cast_nullable_to_non_nullable
as int,costCents: freezed == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int?,costCurrency: null == costCurrency ? _self.costCurrency : costCurrency // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,cookCount: null == cookCount ? _self.cookCount : cookCount // ignore: cast_nullable_to_non_nullable
as int,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Recipe].
extension RecipePatterns on Recipe {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recipe value)  $default,){
final _that = this;
switch (_that) {
case _Recipe():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recipe value)?  $default,){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  DateTime createdAt,  DateTime updatedAt,  String title,  String? forkedFromId,  String? note,  String? coverPath,  CoverStyle coverStyle,  int baseServings,  int? totalMinutes,  RecipeVisibility visibility,  RecipeStatus status,  RecipeSource source,  String? sourceText,  double? kcalPerServing,  double? proteinG,  double? carbsG,  double? fatG,  double? fibreG,  int ingredientCount,  int matchedLines,  int? costCents,  String costCurrency,  int likeCount,  int saveCount,  int cookCount,  DateTime? publishedAt,  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.authorId,_that.createdAt,_that.updatedAt,_that.title,_that.forkedFromId,_that.note,_that.coverPath,_that.coverStyle,_that.baseServings,_that.totalMinutes,_that.visibility,_that.status,_that.source,_that.sourceText,_that.kcalPerServing,_that.proteinG,_that.carbsG,_that.fatG,_that.fibreG,_that.ingredientCount,_that.matchedLines,_that.costCents,_that.costCurrency,_that.likeCount,_that.saveCount,_that.cookCount,_that.publishedAt,_that.deletedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  DateTime createdAt,  DateTime updatedAt,  String title,  String? forkedFromId,  String? note,  String? coverPath,  CoverStyle coverStyle,  int baseServings,  int? totalMinutes,  RecipeVisibility visibility,  RecipeStatus status,  RecipeSource source,  String? sourceText,  double? kcalPerServing,  double? proteinG,  double? carbsG,  double? fatG,  double? fibreG,  int ingredientCount,  int matchedLines,  int? costCents,  String costCurrency,  int likeCount,  int saveCount,  int cookCount,  DateTime? publishedAt,  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.authorId,_that.createdAt,_that.updatedAt,_that.title,_that.forkedFromId,_that.note,_that.coverPath,_that.coverStyle,_that.baseServings,_that.totalMinutes,_that.visibility,_that.status,_that.source,_that.sourceText,_that.kcalPerServing,_that.proteinG,_that.carbsG,_that.fatG,_that.fibreG,_that.ingredientCount,_that.matchedLines,_that.costCents,_that.costCurrency,_that.likeCount,_that.saveCount,_that.cookCount,_that.publishedAt,_that.deletedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  DateTime createdAt,  DateTime updatedAt,  String title,  String? forkedFromId,  String? note,  String? coverPath,  CoverStyle coverStyle,  int baseServings,  int? totalMinutes,  RecipeVisibility visibility,  RecipeStatus status,  RecipeSource source,  String? sourceText,  double? kcalPerServing,  double? proteinG,  double? carbsG,  double? fatG,  double? fibreG,  int ingredientCount,  int matchedLines,  int? costCents,  String costCurrency,  int likeCount,  int saveCount,  int cookCount,  DateTime? publishedAt,  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.authorId,_that.createdAt,_that.updatedAt,_that.title,_that.forkedFromId,_that.note,_that.coverPath,_that.coverStyle,_that.baseServings,_that.totalMinutes,_that.visibility,_that.status,_that.source,_that.sourceText,_that.kcalPerServing,_that.proteinG,_that.carbsG,_that.fatG,_that.fibreG,_that.ingredientCount,_that.matchedLines,_that.costCents,_that.costCurrency,_that.likeCount,_that.saveCount,_that.cookCount,_that.publishedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recipe extends Recipe {
  const _Recipe({required this.id, required this.authorId, required this.createdAt, required this.updatedAt, this.title = '', this.forkedFromId, this.note, this.coverPath, this.coverStyle = CoverStyle.any, this.baseServings = 4, this.totalMinutes, this.visibility = RecipeVisibility.friends, this.status = RecipeStatus.draft, this.source = RecipeSource.typed, this.sourceText, this.kcalPerServing, this.proteinG, this.carbsG, this.fatG, this.fibreG, this.ingredientCount = 0, this.matchedLines = 0, this.costCents, this.costCurrency = 'ZAR', this.likeCount = 0, this.saveCount = 0, this.cookCount = 0, this.publishedAt, this.deletedAt}): super._();
  factory _Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

@override final  String id;
@override final  String authorId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String title;
@override final  String? forkedFromId;
@override final  String? note;
@override final  String? coverPath;
@override@JsonKey() final  CoverStyle coverStyle;
@override@JsonKey() final  int baseServings;
@override final  int? totalMinutes;
@override@JsonKey() final  RecipeVisibility visibility;
@override@JsonKey() final  RecipeStatus status;
@override@JsonKey() final  RecipeSource source;
@override final  String? sourceText;
@override final  double? kcalPerServing;
@override final  double? proteinG;
@override final  double? carbsG;
@override final  double? fatG;
@override final  double? fibreG;
@override@JsonKey() final  int ingredientCount;
@override@JsonKey() final  int matchedLines;
@override final  int? costCents;
@override@JsonKey() final  String costCurrency;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int saveCount;
@override@JsonKey() final  int cookCount;
@override final  DateTime? publishedAt;
@override final  DateTime? deletedAt;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.forkedFromId, forkedFromId) || other.forkedFromId == forkedFromId)&&(identical(other.note, note) || other.note == note)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.coverStyle, coverStyle) || other.coverStyle == coverStyle)&&(identical(other.baseServings, baseServings) || other.baseServings == baseServings)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.kcalPerServing, kcalPerServing) || other.kcalPerServing == kcalPerServing)&&(identical(other.proteinG, proteinG) || other.proteinG == proteinG)&&(identical(other.carbsG, carbsG) || other.carbsG == carbsG)&&(identical(other.fatG, fatG) || other.fatG == fatG)&&(identical(other.fibreG, fibreG) || other.fibreG == fibreG)&&(identical(other.ingredientCount, ingredientCount) || other.ingredientCount == ingredientCount)&&(identical(other.matchedLines, matchedLines) || other.matchedLines == matchedLines)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.costCurrency, costCurrency) || other.costCurrency == costCurrency)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.cookCount, cookCount) || other.cookCount == cookCount)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,authorId,createdAt,updatedAt,title,forkedFromId,note,coverPath,coverStyle,baseServings,totalMinutes,visibility,status,source,sourceText,kcalPerServing,proteinG,carbsG,fatG,fibreG,ingredientCount,matchedLines,costCents,costCurrency,likeCount,saveCount,cookCount,publishedAt,deletedAt]);
}

@override
String toString() {
    return 'Recipe(id: $id, authorId: $authorId, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, forkedFromId: $forkedFromId, note: $note, coverPath: $coverPath, coverStyle: $coverStyle, baseServings: $baseServings, totalMinutes: $totalMinutes, visibility: $visibility, status: $status, source: $source, sourceText: $sourceText, kcalPerServing: $kcalPerServing, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, fibreG: $fibreG, ingredientCount: $ingredientCount, matchedLines: $matchedLines, costCents: $costCents, costCurrency: $costCurrency, likeCount: $likeCount, saveCount: $saveCount, cookCount: $cookCount, publishedAt: $publishedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, DateTime createdAt, DateTime updatedAt, String title, String? forkedFromId, String? note, String? coverPath, CoverStyle coverStyle, int baseServings, int? totalMinutes, RecipeVisibility visibility, RecipeStatus status, RecipeSource source, String? sourceText, double? kcalPerServing, double? proteinG, double? carbsG, double? fatG, double? fibreG, int ingredientCount, int matchedLines, int? costCents, String costCurrency, int likeCount, int saveCount, int cookCount, DateTime? publishedAt, DateTime? deletedAt
});




}
/// @nodoc
class __$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(this._self, this._then);

  final _Recipe _self;
  final $Res Function(_Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? createdAt = null,Object? updatedAt = null,Object? title = null,Object? forkedFromId = freezed,Object? note = freezed,Object? coverPath = freezed,Object? coverStyle = null,Object? baseServings = null,Object? totalMinutes = freezed,Object? visibility = null,Object? status = null,Object? source = null,Object? sourceText = freezed,Object? kcalPerServing = freezed,Object? proteinG = freezed,Object? carbsG = freezed,Object? fatG = freezed,Object? fibreG = freezed,Object? ingredientCount = null,Object? matchedLines = null,Object? costCents = freezed,Object? costCurrency = null,Object? likeCount = null,Object? saveCount = null,Object? cookCount = null,Object? publishedAt = freezed,Object? deletedAt = freezed,}) {
  return _then(_Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,forkedFromId: freezed == forkedFromId ? _self.forkedFromId : forkedFromId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverStyle: null == coverStyle ? _self.coverStyle : coverStyle // ignore: cast_nullable_to_non_nullable
as CoverStyle,baseServings: null == baseServings ? _self.baseServings : baseServings // ignore: cast_nullable_to_non_nullable
as int,totalMinutes: freezed == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as RecipeVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecipeStatus,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as RecipeSource,sourceText: freezed == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String?,kcalPerServing: freezed == kcalPerServing ? _self.kcalPerServing : kcalPerServing // ignore: cast_nullable_to_non_nullable
as double?,proteinG: freezed == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as double?,carbsG: freezed == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as double?,fatG: freezed == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as double?,fibreG: freezed == fibreG ? _self.fibreG : fibreG // ignore: cast_nullable_to_non_nullable
as double?,ingredientCount: null == ingredientCount ? _self.ingredientCount : ingredientCount // ignore: cast_nullable_to_non_nullable
as int,matchedLines: null == matchedLines ? _self.matchedLines : matchedLines // ignore: cast_nullable_to_non_nullable
as int,costCents: freezed == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int?,costCurrency: null == costCurrency ? _self.costCurrency : costCurrency // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,cookCount: null == cookCount ? _self.cookCount : cookCount // ignore: cast_nullable_to_non_nullable
as int,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RecipeIngredient {

 String get id; String get recipeId; int get position; String get rawText; DateTime get updatedAt; String? get section; double? get quantity; String? get unit; String? get portionLabel; String? get foodId; String? get prepNote; double? get grams; int? get costCents; bool get optional;
/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeIngredientCopyWith<RecipeIngredient> get copyWith => _$RecipeIngredientCopyWithImpl<RecipeIngredient>(this as RecipeIngredient, _$identity);

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipeIngredient;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeIngredient&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.recipeId, _this.recipeId) || other.recipeId == _this.recipeId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.rawText, _this.rawText) || other.rawText == _this.rawText)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.section, _this.section) || other.section == _this.section)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.portionLabel, _this.portionLabel) || other.portionLabel == _this.portionLabel)&&(identical(other.foodId, _this.foodId) || other.foodId == _this.foodId)&&(identical(other.prepNote, _this.prepNote) || other.prepNote == _this.prepNote)&&(identical(other.grams, _this.grams) || other.grams == _this.grams)&&(identical(other.costCents, _this.costCents) || other.costCents == _this.costCents)&&(identical(other.optional, _this.optional) || other.optional == _this.optional));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipeIngredient;
  return Object.hash(runtimeType,_this.id,_this.recipeId,_this.position,_this.rawText,_this.updatedAt,_this.section,_this.quantity,_this.unit,_this.portionLabel,_this.foodId,_this.prepNote,_this.grams,_this.costCents,_this.optional);
}

@override
String toString() {
  final _this = this as RecipeIngredient;
  return 'RecipeIngredient(id: ${_this.id}, recipeId: ${_this.recipeId}, position: ${_this.position}, rawText: ${_this.rawText}, updatedAt: ${_this.updatedAt}, section: ${_this.section}, quantity: ${_this.quantity}, unit: ${_this.unit}, portionLabel: ${_this.portionLabel}, foodId: ${_this.foodId}, prepNote: ${_this.prepNote}, grams: ${_this.grams}, costCents: ${_this.costCents}, optional: ${_this.optional})';
}


}

/// @nodoc
abstract mixin class $RecipeIngredientCopyWith<$Res>  {
  factory $RecipeIngredientCopyWith(RecipeIngredient value, $Res Function(RecipeIngredient) _then) = _$RecipeIngredientCopyWithImpl;
@useResult
$Res call({
 String id, String recipeId, int position, String rawText, DateTime updatedAt, String? section, double? quantity, String? unit, String? portionLabel, String? foodId, String? prepNote, double? grams, int? costCents, bool optional
});




}
/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._self, this._then);

  final RecipeIngredient _self;
  final $Res Function(RecipeIngredient) _then;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipeId = null,Object? position = null,Object? rawText = null,Object? updatedAt = null,Object? section = freezed,Object? quantity = freezed,Object? unit = freezed,Object? portionLabel = freezed,Object? foodId = freezed,Object? prepNote = freezed,Object? grams = freezed,Object? costCents = freezed,Object? optional = null,}) {
  return _then(RecipeIngredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,portionLabel: freezed == portionLabel ? _self.portionLabel : portionLabel // ignore: cast_nullable_to_non_nullable
as String?,foodId: freezed == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String?,prepNote: freezed == prepNote ? _self.prepNote : prepNote // ignore: cast_nullable_to_non_nullable
as String?,grams: freezed == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double?,costCents: freezed == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int?,optional: null == optional ? _self.optional : optional // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeIngredient].
extension RecipeIngredientPatterns on RecipeIngredient {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeIngredient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeIngredient value)  $default,){
final _that = this;
switch (_that) {
case _RecipeIngredient():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeIngredient value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recipeId,  int position,  String rawText,  DateTime updatedAt,  String? section,  double? quantity,  String? unit,  String? portionLabel,  String? foodId,  String? prepNote,  double? grams,  int? costCents,  bool optional)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that.id,_that.recipeId,_that.position,_that.rawText,_that.updatedAt,_that.section,_that.quantity,_that.unit,_that.portionLabel,_that.foodId,_that.prepNote,_that.grams,_that.costCents,_that.optional);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recipeId,  int position,  String rawText,  DateTime updatedAt,  String? section,  double? quantity,  String? unit,  String? portionLabel,  String? foodId,  String? prepNote,  double? grams,  int? costCents,  bool optional)  $default,) {final _that = this;
switch (_that) {
case _RecipeIngredient():
return $default(_that.id,_that.recipeId,_that.position,_that.rawText,_that.updatedAt,_that.section,_that.quantity,_that.unit,_that.portionLabel,_that.foodId,_that.prepNote,_that.grams,_that.costCents,_that.optional);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recipeId,  int position,  String rawText,  DateTime updatedAt,  String? section,  double? quantity,  String? unit,  String? portionLabel,  String? foodId,  String? prepNote,  double? grams,  int? costCents,  bool optional)?  $default,) {final _that = this;
switch (_that) {
case _RecipeIngredient() when $default != null:
return $default(_that.id,_that.recipeId,_that.position,_that.rawText,_that.updatedAt,_that.section,_that.quantity,_that.unit,_that.portionLabel,_that.foodId,_that.prepNote,_that.grams,_that.costCents,_that.optional);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeIngredient extends RecipeIngredient {
  const _RecipeIngredient({required this.id, required this.recipeId, required this.position, required this.rawText, required this.updatedAt, this.section, this.quantity, this.unit, this.portionLabel, this.foodId, this.prepNote, this.grams, this.costCents, this.optional = false}): super._();
  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) => _$RecipeIngredientFromJson(json);

@override final  String id;
@override final  String recipeId;
@override final  int position;
@override final  String rawText;
@override final  DateTime updatedAt;
@override final  String? section;
@override final  double? quantity;
@override final  String? unit;
@override final  String? portionLabel;
@override final  String? foodId;
@override final  String? prepNote;
@override final  double? grams;
@override final  int? costCents;
@override@JsonKey() final  bool optional;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeIngredientCopyWith<_RecipeIngredient> get copyWith => __$RecipeIngredientCopyWithImpl<_RecipeIngredient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeIngredientToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeIngredient&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.position, position) || other.position == position)&&(identical(other.rawText, rawText) || other.rawText == rawText)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.section, section) || other.section == section)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.portionLabel, portionLabel) || other.portionLabel == portionLabel)&&(identical(other.foodId, foodId) || other.foodId == foodId)&&(identical(other.prepNote, prepNote) || other.prepNote == prepNote)&&(identical(other.grams, grams) || other.grams == grams)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.optional, optional) || other.optional == optional));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,recipeId,position,rawText,updatedAt,section,quantity,unit,portionLabel,foodId,prepNote,grams,costCents,optional);
}

@override
String toString() {
    return 'RecipeIngredient(id: $id, recipeId: $recipeId, position: $position, rawText: $rawText, updatedAt: $updatedAt, section: $section, quantity: $quantity, unit: $unit, portionLabel: $portionLabel, foodId: $foodId, prepNote: $prepNote, grams: $grams, costCents: $costCents, optional: $optional)';
}


}

/// @nodoc
abstract mixin class _$RecipeIngredientCopyWith<$Res> implements $RecipeIngredientCopyWith<$Res> {
  factory _$RecipeIngredientCopyWith(_RecipeIngredient value, $Res Function(_RecipeIngredient) _then) = __$RecipeIngredientCopyWithImpl;
@override @useResult
$Res call({
 String id, String recipeId, int position, String rawText, DateTime updatedAt, String? section, double? quantity, String? unit, String? portionLabel, String? foodId, String? prepNote, double? grams, int? costCents, bool optional
});




}
/// @nodoc
class __$RecipeIngredientCopyWithImpl<$Res>
    implements _$RecipeIngredientCopyWith<$Res> {
  __$RecipeIngredientCopyWithImpl(this._self, this._then);

  final _RecipeIngredient _self;
  final $Res Function(_RecipeIngredient) _then;

/// Create a copy of RecipeIngredient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipeId = null,Object? position = null,Object? rawText = null,Object? updatedAt = null,Object? section = freezed,Object? quantity = freezed,Object? unit = freezed,Object? portionLabel = freezed,Object? foodId = freezed,Object? prepNote = freezed,Object? grams = freezed,Object? costCents = freezed,Object? optional = null,}) {
  return _then(_RecipeIngredient(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,rawText: null == rawText ? _self.rawText : rawText // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,section: freezed == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as String?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,portionLabel: freezed == portionLabel ? _self.portionLabel : portionLabel // ignore: cast_nullable_to_non_nullable
as String?,foodId: freezed == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String?,prepNote: freezed == prepNote ? _self.prepNote : prepNote // ignore: cast_nullable_to_non_nullable
as String?,grams: freezed == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double?,costCents: freezed == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int?,optional: null == optional ? _self.optional : optional // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$RecipeStep {

 String get id; String get recipeId; int get position; String get body; DateTime get updatedAt; int? get timerSeconds;
/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeStepCopyWith<RecipeStep> get copyWith => _$RecipeStepCopyWithImpl<RecipeStep>(this as RecipeStep, _$identity);

  /// Serializes this RecipeStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipeStep;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeStep&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.recipeId, _this.recipeId) || other.recipeId == _this.recipeId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.timerSeconds, _this.timerSeconds) || other.timerSeconds == _this.timerSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipeStep;
  return Object.hash(runtimeType,_this.id,_this.recipeId,_this.position,_this.body,_this.updatedAt,_this.timerSeconds);
}

@override
String toString() {
  final _this = this as RecipeStep;
  return 'RecipeStep(id: ${_this.id}, recipeId: ${_this.recipeId}, position: ${_this.position}, body: ${_this.body}, updatedAt: ${_this.updatedAt}, timerSeconds: ${_this.timerSeconds})';
}


}

/// @nodoc
abstract mixin class $RecipeStepCopyWith<$Res>  {
  factory $RecipeStepCopyWith(RecipeStep value, $Res Function(RecipeStep) _then) = _$RecipeStepCopyWithImpl;
@useResult
$Res call({
 String id, String recipeId, int position, String body, DateTime updatedAt, int? timerSeconds
});




}
/// @nodoc
class _$RecipeStepCopyWithImpl<$Res>
    implements $RecipeStepCopyWith<$Res> {
  _$RecipeStepCopyWithImpl(this._self, this._then);

  final RecipeStep _self;
  final $Res Function(RecipeStep) _then;

/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? recipeId = null,Object? position = null,Object? body = null,Object? updatedAt = null,Object? timerSeconds = freezed,}) {
  return _then(RecipeStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,timerSeconds: freezed == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeStep].
extension RecipeStepPatterns on RecipeStep {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeStep value)  $default,){
final _that = this;
switch (_that) {
case _RecipeStep():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeStep value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String recipeId,  int position,  String body,  DateTime updatedAt,  int? timerSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
return $default(_that.id,_that.recipeId,_that.position,_that.body,_that.updatedAt,_that.timerSeconds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String recipeId,  int position,  String body,  DateTime updatedAt,  int? timerSeconds)  $default,) {final _that = this;
switch (_that) {
case _RecipeStep():
return $default(_that.id,_that.recipeId,_that.position,_that.body,_that.updatedAt,_that.timerSeconds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String recipeId,  int position,  String body,  DateTime updatedAt,  int? timerSeconds)?  $default,) {final _that = this;
switch (_that) {
case _RecipeStep() when $default != null:
return $default(_that.id,_that.recipeId,_that.position,_that.body,_that.updatedAt,_that.timerSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeStep extends RecipeStep {
  const _RecipeStep({required this.id, required this.recipeId, required this.position, required this.body, required this.updatedAt, this.timerSeconds}): super._();
  factory _RecipeStep.fromJson(Map<String, dynamic> json) => _$RecipeStepFromJson(json);

@override final  String id;
@override final  String recipeId;
@override final  int position;
@override final  String body;
@override final  DateTime updatedAt;
@override final  int? timerSeconds;

/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeStepCopyWith<_RecipeStep> get copyWith => __$RecipeStepCopyWithImpl<_RecipeStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeStepToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeStep&&(identical(other.id, id) || other.id == id)&&(identical(other.recipeId, recipeId) || other.recipeId == recipeId)&&(identical(other.position, position) || other.position == position)&&(identical(other.body, body) || other.body == body)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,recipeId,position,body,updatedAt,timerSeconds);
}

@override
String toString() {
    return 'RecipeStep(id: $id, recipeId: $recipeId, position: $position, body: $body, updatedAt: $updatedAt, timerSeconds: $timerSeconds)';
}


}

/// @nodoc
abstract mixin class _$RecipeStepCopyWith<$Res> implements $RecipeStepCopyWith<$Res> {
  factory _$RecipeStepCopyWith(_RecipeStep value, $Res Function(_RecipeStep) _then) = __$RecipeStepCopyWithImpl;
@override @useResult
$Res call({
 String id, String recipeId, int position, String body, DateTime updatedAt, int? timerSeconds
});




}
/// @nodoc
class __$RecipeStepCopyWithImpl<$Res>
    implements _$RecipeStepCopyWith<$Res> {
  __$RecipeStepCopyWithImpl(this._self, this._then);

  final _RecipeStep _self;
  final $Res Function(_RecipeStep) _then;

/// Create a copy of RecipeStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? recipeId = null,Object? position = null,Object? body = null,Object? updatedAt = null,Object? timerSeconds = freezed,}) {
  return _then(_RecipeStep(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,recipeId: null == recipeId ? _self.recipeId : recipeId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,timerSeconds: freezed == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RecipeCard {

 String get id; String get authorId; String get title; DateTime get updatedAt; String? get authorUsername; String? get authorName; String? get authorAvatar; String? get note; String? get coverPath; CoverStyle get coverStyle; int get baseServings; int? get totalMinutes; RecipeVisibility get visibility; RecipeStatus get status; double? get kcalPerServing; double? get proteinG; double? get carbsG; double? get fatG; double? get fibreG; int get ingredientCount; int get matchedLines; int? get costCents; String get costCurrency; int? get costPerPlate; int get likeCount; int get saveCount; int get cookCount; String? get forkedFromId; DateTime? get publishedAt; bool get isLiked; bool get isSaved; bool get isMine; String? get coverUrl;@JsonKey(includeFromJson: false, includeToJson: false) String? get localCoverPath;
/// Create a copy of RecipeCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCardCopyWith<RecipeCard> get copyWith => _$RecipeCardCopyWithImpl<RecipeCard>(this as RecipeCard, _$identity);

  /// Serializes this RecipeCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipeCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.authorId, _this.authorId) || other.authorId == _this.authorId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.authorUsername, _this.authorUsername) || other.authorUsername == _this.authorUsername)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.authorAvatar, _this.authorAvatar) || other.authorAvatar == _this.authorAvatar)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.coverPath, _this.coverPath) || other.coverPath == _this.coverPath)&&(identical(other.coverStyle, _this.coverStyle) || other.coverStyle == _this.coverStyle)&&(identical(other.baseServings, _this.baseServings) || other.baseServings == _this.baseServings)&&(identical(other.totalMinutes, _this.totalMinutes) || other.totalMinutes == _this.totalMinutes)&&(identical(other.visibility, _this.visibility) || other.visibility == _this.visibility)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.kcalPerServing, _this.kcalPerServing) || other.kcalPerServing == _this.kcalPerServing)&&(identical(other.proteinG, _this.proteinG) || other.proteinG == _this.proteinG)&&(identical(other.carbsG, _this.carbsG) || other.carbsG == _this.carbsG)&&(identical(other.fatG, _this.fatG) || other.fatG == _this.fatG)&&(identical(other.fibreG, _this.fibreG) || other.fibreG == _this.fibreG)&&(identical(other.ingredientCount, _this.ingredientCount) || other.ingredientCount == _this.ingredientCount)&&(identical(other.matchedLines, _this.matchedLines) || other.matchedLines == _this.matchedLines)&&(identical(other.costCents, _this.costCents) || other.costCents == _this.costCents)&&(identical(other.costCurrency, _this.costCurrency) || other.costCurrency == _this.costCurrency)&&(identical(other.costPerPlate, _this.costPerPlate) || other.costPerPlate == _this.costPerPlate)&&(identical(other.likeCount, _this.likeCount) || other.likeCount == _this.likeCount)&&(identical(other.saveCount, _this.saveCount) || other.saveCount == _this.saveCount)&&(identical(other.cookCount, _this.cookCount) || other.cookCount == _this.cookCount)&&(identical(other.forkedFromId, _this.forkedFromId) || other.forkedFromId == _this.forkedFromId)&&(identical(other.publishedAt, _this.publishedAt) || other.publishedAt == _this.publishedAt)&&(identical(other.isLiked, _this.isLiked) || other.isLiked == _this.isLiked)&&(identical(other.isSaved, _this.isSaved) || other.isSaved == _this.isSaved)&&(identical(other.isMine, _this.isMine) || other.isMine == _this.isMine)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.localCoverPath, _this.localCoverPath) || other.localCoverPath == _this.localCoverPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipeCard;
  return Object.hashAll([runtimeType,_this.id,_this.authorId,_this.title,_this.updatedAt,_this.authorUsername,_this.authorName,_this.authorAvatar,_this.note,_this.coverPath,_this.coverStyle,_this.baseServings,_this.totalMinutes,_this.visibility,_this.status,_this.kcalPerServing,_this.proteinG,_this.carbsG,_this.fatG,_this.fibreG,_this.ingredientCount,_this.matchedLines,_this.costCents,_this.costCurrency,_this.costPerPlate,_this.likeCount,_this.saveCount,_this.cookCount,_this.forkedFromId,_this.publishedAt,_this.isLiked,_this.isSaved,_this.isMine,_this.coverUrl,_this.localCoverPath]);
}

@override
String toString() {
  final _this = this as RecipeCard;
  return 'RecipeCard(id: ${_this.id}, authorId: ${_this.authorId}, title: ${_this.title}, updatedAt: ${_this.updatedAt}, authorUsername: ${_this.authorUsername}, authorName: ${_this.authorName}, authorAvatar: ${_this.authorAvatar}, note: ${_this.note}, coverPath: ${_this.coverPath}, coverStyle: ${_this.coverStyle}, baseServings: ${_this.baseServings}, totalMinutes: ${_this.totalMinutes}, visibility: ${_this.visibility}, status: ${_this.status}, kcalPerServing: ${_this.kcalPerServing}, proteinG: ${_this.proteinG}, carbsG: ${_this.carbsG}, fatG: ${_this.fatG}, fibreG: ${_this.fibreG}, ingredientCount: ${_this.ingredientCount}, matchedLines: ${_this.matchedLines}, costCents: ${_this.costCents}, costCurrency: ${_this.costCurrency}, costPerPlate: ${_this.costPerPlate}, likeCount: ${_this.likeCount}, saveCount: ${_this.saveCount}, cookCount: ${_this.cookCount}, forkedFromId: ${_this.forkedFromId}, publishedAt: ${_this.publishedAt}, isLiked: ${_this.isLiked}, isSaved: ${_this.isSaved}, isMine: ${_this.isMine}, coverUrl: ${_this.coverUrl}, localCoverPath: ${_this.localCoverPath})';
}


}

/// @nodoc
abstract mixin class $RecipeCardCopyWith<$Res>  {
  factory $RecipeCardCopyWith(RecipeCard value, $Res Function(RecipeCard) _then) = _$RecipeCardCopyWithImpl;
@useResult
$Res call({
 String id, String authorId, String title, DateTime updatedAt, String? authorUsername, String? authorName, String? authorAvatar, String? note, String? coverPath, CoverStyle coverStyle, int baseServings, int? totalMinutes, RecipeVisibility visibility, RecipeStatus status, double? kcalPerServing, double? proteinG, double? carbsG, double? fatG, double? fibreG, int ingredientCount, int matchedLines, int? costCents, String costCurrency, int? costPerPlate, int likeCount, int saveCount, int cookCount, String? forkedFromId, DateTime? publishedAt, bool isLiked, bool isSaved, bool isMine, String? coverUrl,@JsonKey(includeFromJson: false, includeToJson: false) String? localCoverPath
});




}
/// @nodoc
class _$RecipeCardCopyWithImpl<$Res>
    implements $RecipeCardCopyWith<$Res> {
  _$RecipeCardCopyWithImpl(this._self, this._then);

  final RecipeCard _self;
  final $Res Function(RecipeCard) _then;

/// Create a copy of RecipeCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorId = null,Object? title = null,Object? updatedAt = null,Object? authorUsername = freezed,Object? authorName = freezed,Object? authorAvatar = freezed,Object? note = freezed,Object? coverPath = freezed,Object? coverStyle = null,Object? baseServings = null,Object? totalMinutes = freezed,Object? visibility = null,Object? status = null,Object? kcalPerServing = freezed,Object? proteinG = freezed,Object? carbsG = freezed,Object? fatG = freezed,Object? fibreG = freezed,Object? ingredientCount = null,Object? matchedLines = null,Object? costCents = freezed,Object? costCurrency = null,Object? costPerPlate = freezed,Object? likeCount = null,Object? saveCount = null,Object? cookCount = null,Object? forkedFromId = freezed,Object? publishedAt = freezed,Object? isLiked = null,Object? isSaved = null,Object? isMine = null,Object? coverUrl = freezed,Object? localCoverPath = freezed,}) {
  return _then(RecipeCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorUsername: freezed == authorUsername ? _self.authorUsername : authorUsername // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverStyle: null == coverStyle ? _self.coverStyle : coverStyle // ignore: cast_nullable_to_non_nullable
as CoverStyle,baseServings: null == baseServings ? _self.baseServings : baseServings // ignore: cast_nullable_to_non_nullable
as int,totalMinutes: freezed == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as RecipeVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecipeStatus,kcalPerServing: freezed == kcalPerServing ? _self.kcalPerServing : kcalPerServing // ignore: cast_nullable_to_non_nullable
as double?,proteinG: freezed == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as double?,carbsG: freezed == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as double?,fatG: freezed == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as double?,fibreG: freezed == fibreG ? _self.fibreG : fibreG // ignore: cast_nullable_to_non_nullable
as double?,ingredientCount: null == ingredientCount ? _self.ingredientCount : ingredientCount // ignore: cast_nullable_to_non_nullable
as int,matchedLines: null == matchedLines ? _self.matchedLines : matchedLines // ignore: cast_nullable_to_non_nullable
as int,costCents: freezed == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int?,costCurrency: null == costCurrency ? _self.costCurrency : costCurrency // ignore: cast_nullable_to_non_nullable
as String,costPerPlate: freezed == costPerPlate ? _self.costPerPlate : costPerPlate // ignore: cast_nullable_to_non_nullable
as int?,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,cookCount: null == cookCount ? _self.cookCount : cookCount // ignore: cast_nullable_to_non_nullable
as int,forkedFromId: freezed == forkedFromId ? _self.forkedFromId : forkedFromId // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,localCoverPath: freezed == localCoverPath ? _self.localCoverPath : localCoverPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeCard].
extension RecipeCardPatterns on RecipeCard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeCard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeCard value)  $default,){
final _that = this;
switch (_that) {
case _RecipeCard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeCard value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeCard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String authorId,  String title,  DateTime updatedAt,  String? authorUsername,  String? authorName,  String? authorAvatar,  String? note,  String? coverPath,  CoverStyle coverStyle,  int baseServings,  int? totalMinutes,  RecipeVisibility visibility,  RecipeStatus status,  double? kcalPerServing,  double? proteinG,  double? carbsG,  double? fatG,  double? fibreG,  int ingredientCount,  int matchedLines,  int? costCents,  String costCurrency,  int? costPerPlate,  int likeCount,  int saveCount,  int cookCount,  String? forkedFromId,  DateTime? publishedAt,  bool isLiked,  bool isSaved,  bool isMine,  String? coverUrl, @JsonKey(includeFromJson: false, includeToJson: false)  String? localCoverPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeCard() when $default != null:
return $default(_that.id,_that.authorId,_that.title,_that.updatedAt,_that.authorUsername,_that.authorName,_that.authorAvatar,_that.note,_that.coverPath,_that.coverStyle,_that.baseServings,_that.totalMinutes,_that.visibility,_that.status,_that.kcalPerServing,_that.proteinG,_that.carbsG,_that.fatG,_that.fibreG,_that.ingredientCount,_that.matchedLines,_that.costCents,_that.costCurrency,_that.costPerPlate,_that.likeCount,_that.saveCount,_that.cookCount,_that.forkedFromId,_that.publishedAt,_that.isLiked,_that.isSaved,_that.isMine,_that.coverUrl,_that.localCoverPath);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String authorId,  String title,  DateTime updatedAt,  String? authorUsername,  String? authorName,  String? authorAvatar,  String? note,  String? coverPath,  CoverStyle coverStyle,  int baseServings,  int? totalMinutes,  RecipeVisibility visibility,  RecipeStatus status,  double? kcalPerServing,  double? proteinG,  double? carbsG,  double? fatG,  double? fibreG,  int ingredientCount,  int matchedLines,  int? costCents,  String costCurrency,  int? costPerPlate,  int likeCount,  int saveCount,  int cookCount,  String? forkedFromId,  DateTime? publishedAt,  bool isLiked,  bool isSaved,  bool isMine,  String? coverUrl, @JsonKey(includeFromJson: false, includeToJson: false)  String? localCoverPath)  $default,) {final _that = this;
switch (_that) {
case _RecipeCard():
return $default(_that.id,_that.authorId,_that.title,_that.updatedAt,_that.authorUsername,_that.authorName,_that.authorAvatar,_that.note,_that.coverPath,_that.coverStyle,_that.baseServings,_that.totalMinutes,_that.visibility,_that.status,_that.kcalPerServing,_that.proteinG,_that.carbsG,_that.fatG,_that.fibreG,_that.ingredientCount,_that.matchedLines,_that.costCents,_that.costCurrency,_that.costPerPlate,_that.likeCount,_that.saveCount,_that.cookCount,_that.forkedFromId,_that.publishedAt,_that.isLiked,_that.isSaved,_that.isMine,_that.coverUrl,_that.localCoverPath);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String authorId,  String title,  DateTime updatedAt,  String? authorUsername,  String? authorName,  String? authorAvatar,  String? note,  String? coverPath,  CoverStyle coverStyle,  int baseServings,  int? totalMinutes,  RecipeVisibility visibility,  RecipeStatus status,  double? kcalPerServing,  double? proteinG,  double? carbsG,  double? fatG,  double? fibreG,  int ingredientCount,  int matchedLines,  int? costCents,  String costCurrency,  int? costPerPlate,  int likeCount,  int saveCount,  int cookCount,  String? forkedFromId,  DateTime? publishedAt,  bool isLiked,  bool isSaved,  bool isMine,  String? coverUrl, @JsonKey(includeFromJson: false, includeToJson: false)  String? localCoverPath)?  $default,) {final _that = this;
switch (_that) {
case _RecipeCard() when $default != null:
return $default(_that.id,_that.authorId,_that.title,_that.updatedAt,_that.authorUsername,_that.authorName,_that.authorAvatar,_that.note,_that.coverPath,_that.coverStyle,_that.baseServings,_that.totalMinutes,_that.visibility,_that.status,_that.kcalPerServing,_that.proteinG,_that.carbsG,_that.fatG,_that.fibreG,_that.ingredientCount,_that.matchedLines,_that.costCents,_that.costCurrency,_that.costPerPlate,_that.likeCount,_that.saveCount,_that.cookCount,_that.forkedFromId,_that.publishedAt,_that.isLiked,_that.isSaved,_that.isMine,_that.coverUrl,_that.localCoverPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeCard implements RecipeCard {
  const _RecipeCard({required this.id, required this.authorId, required this.title, required this.updatedAt, this.authorUsername, this.authorName, this.authorAvatar, this.note, this.coverPath, this.coverStyle = CoverStyle.any, this.baseServings = 4, this.totalMinutes, this.visibility = RecipeVisibility.friends, this.status = RecipeStatus.published, this.kcalPerServing, this.proteinG, this.carbsG, this.fatG, this.fibreG, this.ingredientCount = 0, this.matchedLines = 0, this.costCents, this.costCurrency = 'ZAR', this.costPerPlate, this.likeCount = 0, this.saveCount = 0, this.cookCount = 0, this.forkedFromId, this.publishedAt, this.isLiked = false, this.isSaved = false, this.isMine = false, this.coverUrl, @JsonKey(includeFromJson: false, includeToJson: false) this.localCoverPath});
  factory _RecipeCard.fromJson(Map<String, dynamic> json) => _$RecipeCardFromJson(json);

@override final  String id;
@override final  String authorId;
@override final  String title;
@override final  DateTime updatedAt;
@override final  String? authorUsername;
@override final  String? authorName;
@override final  String? authorAvatar;
@override final  String? note;
@override final  String? coverPath;
@override@JsonKey() final  CoverStyle coverStyle;
@override@JsonKey() final  int baseServings;
@override final  int? totalMinutes;
@override@JsonKey() final  RecipeVisibility visibility;
@override@JsonKey() final  RecipeStatus status;
@override final  double? kcalPerServing;
@override final  double? proteinG;
@override final  double? carbsG;
@override final  double? fatG;
@override final  double? fibreG;
@override@JsonKey() final  int ingredientCount;
@override@JsonKey() final  int matchedLines;
@override final  int? costCents;
@override@JsonKey() final  String costCurrency;
@override final  int? costPerPlate;
@override@JsonKey() final  int likeCount;
@override@JsonKey() final  int saveCount;
@override@JsonKey() final  int cookCount;
@override final  String? forkedFromId;
@override final  DateTime? publishedAt;
@override@JsonKey() final  bool isLiked;
@override@JsonKey() final  bool isSaved;
@override@JsonKey() final  bool isMine;
@override final  String? coverUrl;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? localCoverPath;

/// Create a copy of RecipeCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCardCopyWith<_RecipeCard> get copyWith => __$RecipeCardCopyWithImpl<_RecipeCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeCard&&(identical(other.id, id) || other.id == id)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.title, title) || other.title == title)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.authorUsername, authorUsername) || other.authorUsername == authorUsername)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatar, authorAvatar) || other.authorAvatar == authorAvatar)&&(identical(other.note, note) || other.note == note)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.coverStyle, coverStyle) || other.coverStyle == coverStyle)&&(identical(other.baseServings, baseServings) || other.baseServings == baseServings)&&(identical(other.totalMinutes, totalMinutes) || other.totalMinutes == totalMinutes)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.status, status) || other.status == status)&&(identical(other.kcalPerServing, kcalPerServing) || other.kcalPerServing == kcalPerServing)&&(identical(other.proteinG, proteinG) || other.proteinG == proteinG)&&(identical(other.carbsG, carbsG) || other.carbsG == carbsG)&&(identical(other.fatG, fatG) || other.fatG == fatG)&&(identical(other.fibreG, fibreG) || other.fibreG == fibreG)&&(identical(other.ingredientCount, ingredientCount) || other.ingredientCount == ingredientCount)&&(identical(other.matchedLines, matchedLines) || other.matchedLines == matchedLines)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.costCurrency, costCurrency) || other.costCurrency == costCurrency)&&(identical(other.costPerPlate, costPerPlate) || other.costPerPlate == costPerPlate)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.saveCount, saveCount) || other.saveCount == saveCount)&&(identical(other.cookCount, cookCount) || other.cookCount == cookCount)&&(identical(other.forkedFromId, forkedFromId) || other.forkedFromId == forkedFromId)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.localCoverPath, localCoverPath) || other.localCoverPath == localCoverPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,authorId,title,updatedAt,authorUsername,authorName,authorAvatar,note,coverPath,coverStyle,baseServings,totalMinutes,visibility,status,kcalPerServing,proteinG,carbsG,fatG,fibreG,ingredientCount,matchedLines,costCents,costCurrency,costPerPlate,likeCount,saveCount,cookCount,forkedFromId,publishedAt,isLiked,isSaved,isMine,coverUrl,localCoverPath]);
}

@override
String toString() {
    return 'RecipeCard(id: $id, authorId: $authorId, title: $title, updatedAt: $updatedAt, authorUsername: $authorUsername, authorName: $authorName, authorAvatar: $authorAvatar, note: $note, coverPath: $coverPath, coverStyle: $coverStyle, baseServings: $baseServings, totalMinutes: $totalMinutes, visibility: $visibility, status: $status, kcalPerServing: $kcalPerServing, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, fibreG: $fibreG, ingredientCount: $ingredientCount, matchedLines: $matchedLines, costCents: $costCents, costCurrency: $costCurrency, costPerPlate: $costPerPlate, likeCount: $likeCount, saveCount: $saveCount, cookCount: $cookCount, forkedFromId: $forkedFromId, publishedAt: $publishedAt, isLiked: $isLiked, isSaved: $isSaved, isMine: $isMine, coverUrl: $coverUrl, localCoverPath: $localCoverPath)';
}


}

/// @nodoc
abstract mixin class _$RecipeCardCopyWith<$Res> implements $RecipeCardCopyWith<$Res> {
  factory _$RecipeCardCopyWith(_RecipeCard value, $Res Function(_RecipeCard) _then) = __$RecipeCardCopyWithImpl;
@override @useResult
$Res call({
 String id, String authorId, String title, DateTime updatedAt, String? authorUsername, String? authorName, String? authorAvatar, String? note, String? coverPath, CoverStyle coverStyle, int baseServings, int? totalMinutes, RecipeVisibility visibility, RecipeStatus status, double? kcalPerServing, double? proteinG, double? carbsG, double? fatG, double? fibreG, int ingredientCount, int matchedLines, int? costCents, String costCurrency, int? costPerPlate, int likeCount, int saveCount, int cookCount, String? forkedFromId, DateTime? publishedAt, bool isLiked, bool isSaved, bool isMine, String? coverUrl,@JsonKey(includeFromJson: false, includeToJson: false) String? localCoverPath
});




}
/// @nodoc
class __$RecipeCardCopyWithImpl<$Res>
    implements _$RecipeCardCopyWith<$Res> {
  __$RecipeCardCopyWithImpl(this._self, this._then);

  final _RecipeCard _self;
  final $Res Function(_RecipeCard) _then;

/// Create a copy of RecipeCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorId = null,Object? title = null,Object? updatedAt = null,Object? authorUsername = freezed,Object? authorName = freezed,Object? authorAvatar = freezed,Object? note = freezed,Object? coverPath = freezed,Object? coverStyle = null,Object? baseServings = null,Object? totalMinutes = freezed,Object? visibility = null,Object? status = null,Object? kcalPerServing = freezed,Object? proteinG = freezed,Object? carbsG = freezed,Object? fatG = freezed,Object? fibreG = freezed,Object? ingredientCount = null,Object? matchedLines = null,Object? costCents = freezed,Object? costCurrency = null,Object? costPerPlate = freezed,Object? likeCount = null,Object? saveCount = null,Object? cookCount = null,Object? forkedFromId = freezed,Object? publishedAt = freezed,Object? isLiked = null,Object? isSaved = null,Object? isMine = null,Object? coverUrl = freezed,Object? localCoverPath = freezed,}) {
  return _then(_RecipeCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorId: null == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorUsername: freezed == authorUsername ? _self.authorUsername : authorUsername // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,authorAvatar: freezed == authorAvatar ? _self.authorAvatar : authorAvatar // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,coverStyle: null == coverStyle ? _self.coverStyle : coverStyle // ignore: cast_nullable_to_non_nullable
as CoverStyle,baseServings: null == baseServings ? _self.baseServings : baseServings // ignore: cast_nullable_to_non_nullable
as int,totalMinutes: freezed == totalMinutes ? _self.totalMinutes : totalMinutes // ignore: cast_nullable_to_non_nullable
as int?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as RecipeVisibility,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecipeStatus,kcalPerServing: freezed == kcalPerServing ? _self.kcalPerServing : kcalPerServing // ignore: cast_nullable_to_non_nullable
as double?,proteinG: freezed == proteinG ? _self.proteinG : proteinG // ignore: cast_nullable_to_non_nullable
as double?,carbsG: freezed == carbsG ? _self.carbsG : carbsG // ignore: cast_nullable_to_non_nullable
as double?,fatG: freezed == fatG ? _self.fatG : fatG // ignore: cast_nullable_to_non_nullable
as double?,fibreG: freezed == fibreG ? _self.fibreG : fibreG // ignore: cast_nullable_to_non_nullable
as double?,ingredientCount: null == ingredientCount ? _self.ingredientCount : ingredientCount // ignore: cast_nullable_to_non_nullable
as int,matchedLines: null == matchedLines ? _self.matchedLines : matchedLines // ignore: cast_nullable_to_non_nullable
as int,costCents: freezed == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int?,costCurrency: null == costCurrency ? _self.costCurrency : costCurrency // ignore: cast_nullable_to_non_nullable
as String,costPerPlate: freezed == costPerPlate ? _self.costPerPlate : costPerPlate // ignore: cast_nullable_to_non_nullable
as int?,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,saveCount: null == saveCount ? _self.saveCount : saveCount // ignore: cast_nullable_to_non_nullable
as int,cookCount: null == cookCount ? _self.cookCount : cookCount // ignore: cast_nullable_to_non_nullable
as int,forkedFromId: freezed == forkedFromId ? _self.forkedFromId : forkedFromId // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,localCoverPath: freezed == localCoverPath ? _self.localCoverPath : localCoverPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
