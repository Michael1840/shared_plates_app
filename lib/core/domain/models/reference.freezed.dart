// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tag {

 int get id; String get slug; String get label; TagKind get kind; DateTime get updatedAt; CoverStyle get coverStyle; int get position;
/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagCopyWith<Tag> get copyWith => _$TagCopyWithImpl<Tag>(this as Tag, _$identity);

  /// Serializes this Tag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Tag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tag&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.coverStyle, _this.coverStyle) || other.coverStyle == _this.coverStyle)&&(identical(other.position, _this.position) || other.position == _this.position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Tag;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.label,_this.kind,_this.updatedAt,_this.coverStyle,_this.position);
}

@override
String toString() {
  final _this = this as Tag;
  return 'Tag(id: ${_this.id}, slug: ${_this.slug}, label: ${_this.label}, kind: ${_this.kind}, updatedAt: ${_this.updatedAt}, coverStyle: ${_this.coverStyle}, position: ${_this.position})';
}


}

/// @nodoc
abstract mixin class $TagCopyWith<$Res>  {
  factory $TagCopyWith(Tag value, $Res Function(Tag) _then) = _$TagCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String label, TagKind kind, DateTime updatedAt, CoverStyle coverStyle, int position
});




}
/// @nodoc
class _$TagCopyWithImpl<$Res>
    implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._self, this._then);

  final Tag _self;
  final $Res Function(Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? label = null,Object? kind = null,Object? updatedAt = null,Object? coverStyle = null,Object? position = null,}) {
  return _then(Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TagKind,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverStyle: null == coverStyle ? _self.coverStyle : coverStyle // ignore: cast_nullable_to_non_nullable
as CoverStyle,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Tag].
extension TagPatterns on Tag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tag value)  $default,){
final _that = this;
switch (_that) {
case _Tag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tag value)?  $default,){
final _that = this;
switch (_that) {
case _Tag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String label,  TagKind kind,  DateTime updatedAt,  CoverStyle coverStyle,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.slug,_that.label,_that.kind,_that.updatedAt,_that.coverStyle,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String label,  TagKind kind,  DateTime updatedAt,  CoverStyle coverStyle,  int position)  $default,) {final _that = this;
switch (_that) {
case _Tag():
return $default(_that.id,_that.slug,_that.label,_that.kind,_that.updatedAt,_that.coverStyle,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String label,  TagKind kind,  DateTime updatedAt,  CoverStyle coverStyle,  int position)?  $default,) {final _that = this;
switch (_that) {
case _Tag() when $default != null:
return $default(_that.id,_that.slug,_that.label,_that.kind,_that.updatedAt,_that.coverStyle,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tag implements Tag {
  const _Tag({required this.id, required this.slug, required this.label, required this.kind, required this.updatedAt, this.coverStyle = CoverStyle.any, this.position = 0});
  factory _Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

@override final  int id;
@override final  String slug;
@override final  String label;
@override final  TagKind kind;
@override final  DateTime updatedAt;
@override@JsonKey() final  CoverStyle coverStyle;
@override@JsonKey() final  int position;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagCopyWith<_Tag> get copyWith => __$TagCopyWithImpl<_Tag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tag&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.label, label) || other.label == label)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.coverStyle, coverStyle) || other.coverStyle == coverStyle)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,label,kind,updatedAt,coverStyle,position);
}

@override
String toString() {
    return 'Tag(id: $id, slug: $slug, label: $label, kind: $kind, updatedAt: $updatedAt, coverStyle: $coverStyle, position: $position)';
}


}

/// @nodoc
abstract mixin class _$TagCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$TagCopyWith(_Tag value, $Res Function(_Tag) _then) = __$TagCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String label, TagKind kind, DateTime updatedAt, CoverStyle coverStyle, int position
});




}
/// @nodoc
class __$TagCopyWithImpl<$Res>
    implements _$TagCopyWith<$Res> {
  __$TagCopyWithImpl(this._self, this._then);

  final _Tag _self;
  final $Res Function(_Tag) _then;

/// Create a copy of Tag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? label = null,Object? kind = null,Object? updatedAt = null,Object? coverStyle = null,Object? position = null,}) {
  return _then(_Tag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TagKind,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,coverStyle: null == coverStyle ? _self.coverStyle : coverStyle // ignore: cast_nullable_to_non_nullable
as CoverStyle,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MeasureUnit {

 String get code; String get label; UnitKind get kind; UnitScope get scope; double get toBase; DateTime get updatedAt;
/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasureUnitCopyWith<MeasureUnit> get copyWith => _$MeasureUnitCopyWithImpl<MeasureUnit>(this as MeasureUnit, _$identity);

  /// Serializes this MeasureUnit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MeasureUnit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasureUnit&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.scope, _this.scope) || other.scope == _this.scope)&&(identical(other.toBase, _this.toBase) || other.toBase == _this.toBase)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MeasureUnit;
  return Object.hash(runtimeType,_this.code,_this.label,_this.kind,_this.scope,_this.toBase,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MeasureUnit;
  return 'MeasureUnit(code: ${_this.code}, label: ${_this.label}, kind: ${_this.kind}, scope: ${_this.scope}, toBase: ${_this.toBase}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MeasureUnitCopyWith<$Res>  {
  factory $MeasureUnitCopyWith(MeasureUnit value, $Res Function(MeasureUnit) _then) = _$MeasureUnitCopyWithImpl;
@useResult
$Res call({
 String code, String label, UnitKind kind, UnitScope scope, double toBase, DateTime updatedAt
});




}
/// @nodoc
class _$MeasureUnitCopyWithImpl<$Res>
    implements $MeasureUnitCopyWith<$Res> {
  _$MeasureUnitCopyWithImpl(this._self, this._then);

  final MeasureUnit _self;
  final $Res Function(MeasureUnit) _then;

/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? label = null,Object? kind = null,Object? scope = null,Object? toBase = null,Object? updatedAt = null,}) {
  return _then(MeasureUnit(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as UnitKind,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as UnitScope,toBase: null == toBase ? _self.toBase : toBase // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasureUnit].
extension MeasureUnitPatterns on MeasureUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasureUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasureUnit value)  $default,){
final _that = this;
switch (_that) {
case _MeasureUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasureUnit value)?  $default,){
final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String label,  UnitKind kind,  UnitScope scope,  double toBase,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
return $default(_that.code,_that.label,_that.kind,_that.scope,_that.toBase,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String label,  UnitKind kind,  UnitScope scope,  double toBase,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MeasureUnit():
return $default(_that.code,_that.label,_that.kind,_that.scope,_that.toBase,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String label,  UnitKind kind,  UnitScope scope,  double toBase,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MeasureUnit() when $default != null:
return $default(_that.code,_that.label,_that.kind,_that.scope,_that.toBase,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeasureUnit implements MeasureUnit {
  const _MeasureUnit({required this.code, required this.label, required this.kind, required this.scope, required this.toBase, required this.updatedAt});
  factory _MeasureUnit.fromJson(Map<String, dynamic> json) => _$MeasureUnitFromJson(json);

@override final  String code;
@override final  String label;
@override final  UnitKind kind;
@override final  UnitScope scope;
@override final  double toBase;
@override final  DateTime updatedAt;

/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasureUnitCopyWith<_MeasureUnit> get copyWith => __$MeasureUnitCopyWithImpl<_MeasureUnit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeasureUnitToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasureUnit&&(identical(other.code, code) || other.code == code)&&(identical(other.label, label) || other.label == label)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.toBase, toBase) || other.toBase == toBase)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,label,kind,scope,toBase,updatedAt);
}

@override
String toString() {
    return 'MeasureUnit(code: $code, label: $label, kind: $kind, scope: $scope, toBase: $toBase, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MeasureUnitCopyWith<$Res> implements $MeasureUnitCopyWith<$Res> {
  factory _$MeasureUnitCopyWith(_MeasureUnit value, $Res Function(_MeasureUnit) _then) = __$MeasureUnitCopyWithImpl;
@override @useResult
$Res call({
 String code, String label, UnitKind kind, UnitScope scope, double toBase, DateTime updatedAt
});




}
/// @nodoc
class __$MeasureUnitCopyWithImpl<$Res>
    implements _$MeasureUnitCopyWith<$Res> {
  __$MeasureUnitCopyWithImpl(this._self, this._then);

  final _MeasureUnit _self;
  final $Res Function(_MeasureUnit) _then;

/// Create a copy of MeasureUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? label = null,Object? kind = null,Object? scope = null,Object? toBase = null,Object? updatedAt = null,}) {
  return _then(_MeasureUnit(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as UnitKind,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as UnitScope,toBase: null == toBase ? _self.toBase : toBase // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Food {

 String get id; String get name; DateTime get updatedAt; List<String> get aliases; String? get category;@JsonKey(name: 'kcal_100g') double get kcal100g;@JsonKey(name: 'protein_100g') double get protein100g;@JsonKey(name: 'carbs_100g') double get carbs100g;@JsonKey(name: 'fat_100g') double get fat100g;@JsonKey(name: 'fibre_100g') double get fibre100g;@JsonKey(name: 'sugar_100g') double? get sugar100g;@JsonKey(name: 'sodium_mg_100g') double? get sodiumMg100g; double? get densityGMl;
/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCopyWith<Food> get copyWith => _$FoodCopyWithImpl<Food>(this as Food, _$identity);

  /// Serializes this Food to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Food;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Food&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.aliases, _this.aliases)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.kcal100g, _this.kcal100g) || other.kcal100g == _this.kcal100g)&&(identical(other.protein100g, _this.protein100g) || other.protein100g == _this.protein100g)&&(identical(other.carbs100g, _this.carbs100g) || other.carbs100g == _this.carbs100g)&&(identical(other.fat100g, _this.fat100g) || other.fat100g == _this.fat100g)&&(identical(other.fibre100g, _this.fibre100g) || other.fibre100g == _this.fibre100g)&&(identical(other.sugar100g, _this.sugar100g) || other.sugar100g == _this.sugar100g)&&(identical(other.sodiumMg100g, _this.sodiumMg100g) || other.sodiumMg100g == _this.sodiumMg100g)&&(identical(other.densityGMl, _this.densityGMl) || other.densityGMl == _this.densityGMl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Food;
  return Object.hash(runtimeType,_this.id,_this.name,_this.updatedAt,const DeepCollectionEquality().hash(_this.aliases),_this.category,_this.kcal100g,_this.protein100g,_this.carbs100g,_this.fat100g,_this.fibre100g,_this.sugar100g,_this.sodiumMg100g,_this.densityGMl);
}

@override
String toString() {
  final _this = this as Food;
  return 'Food(id: ${_this.id}, name: ${_this.name}, updatedAt: ${_this.updatedAt}, aliases: ${_this.aliases}, category: ${_this.category}, kcal100g: ${_this.kcal100g}, protein100g: ${_this.protein100g}, carbs100g: ${_this.carbs100g}, fat100g: ${_this.fat100g}, fibre100g: ${_this.fibre100g}, sugar100g: ${_this.sugar100g}, sodiumMg100g: ${_this.sodiumMg100g}, densityGMl: ${_this.densityGMl})';
}


}

/// @nodoc
abstract mixin class $FoodCopyWith<$Res>  {
  factory $FoodCopyWith(Food value, $Res Function(Food) _then) = _$FoodCopyWithImpl;
@useResult
$Res call({
 String id, String name, DateTime updatedAt, List<String> aliases, String? category,@JsonKey(name: 'kcal_100g') double kcal100g,@JsonKey(name: 'protein_100g') double protein100g,@JsonKey(name: 'carbs_100g') double carbs100g,@JsonKey(name: 'fat_100g') double fat100g,@JsonKey(name: 'fibre_100g') double fibre100g,@JsonKey(name: 'sugar_100g') double? sugar100g,@JsonKey(name: 'sodium_mg_100g') double? sodiumMg100g, double? densityGMl
});




}
/// @nodoc
class _$FoodCopyWithImpl<$Res>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._self, this._then);

  final Food _self;
  final $Res Function(Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? updatedAt = null,Object? aliases = null,Object? category = freezed,Object? kcal100g = null,Object? protein100g = null,Object? carbs100g = null,Object? fat100g = null,Object? fibre100g = null,Object? sugar100g = freezed,Object? sodiumMg100g = freezed,Object? densityGMl = freezed,}) {
  return _then(Food(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,aliases: null == aliases ? _self.aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,kcal100g: null == kcal100g ? _self.kcal100g : kcal100g // ignore: cast_nullable_to_non_nullable
as double,protein100g: null == protein100g ? _self.protein100g : protein100g // ignore: cast_nullable_to_non_nullable
as double,carbs100g: null == carbs100g ? _self.carbs100g : carbs100g // ignore: cast_nullable_to_non_nullable
as double,fat100g: null == fat100g ? _self.fat100g : fat100g // ignore: cast_nullable_to_non_nullable
as double,fibre100g: null == fibre100g ? _self.fibre100g : fibre100g // ignore: cast_nullable_to_non_nullable
as double,sugar100g: freezed == sugar100g ? _self.sugar100g : sugar100g // ignore: cast_nullable_to_non_nullable
as double?,sodiumMg100g: freezed == sodiumMg100g ? _self.sodiumMg100g : sodiumMg100g // ignore: cast_nullable_to_non_nullable
as double?,densityGMl: freezed == densityGMl ? _self.densityGMl : densityGMl // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Food].
extension FoodPatterns on Food {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Food value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Food() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Food value)  $default,){
final _that = this;
switch (_that) {
case _Food():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Food value)?  $default,){
final _that = this;
switch (_that) {
case _Food() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  DateTime updatedAt,  List<String> aliases,  String? category, @JsonKey(name: 'kcal_100g')  double kcal100g, @JsonKey(name: 'protein_100g')  double protein100g, @JsonKey(name: 'carbs_100g')  double carbs100g, @JsonKey(name: 'fat_100g')  double fat100g, @JsonKey(name: 'fibre_100g')  double fibre100g, @JsonKey(name: 'sugar_100g')  double? sugar100g, @JsonKey(name: 'sodium_mg_100g')  double? sodiumMg100g,  double? densityGMl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.updatedAt,_that.aliases,_that.category,_that.kcal100g,_that.protein100g,_that.carbs100g,_that.fat100g,_that.fibre100g,_that.sugar100g,_that.sodiumMg100g,_that.densityGMl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  DateTime updatedAt,  List<String> aliases,  String? category, @JsonKey(name: 'kcal_100g')  double kcal100g, @JsonKey(name: 'protein_100g')  double protein100g, @JsonKey(name: 'carbs_100g')  double carbs100g, @JsonKey(name: 'fat_100g')  double fat100g, @JsonKey(name: 'fibre_100g')  double fibre100g, @JsonKey(name: 'sugar_100g')  double? sugar100g, @JsonKey(name: 'sodium_mg_100g')  double? sodiumMg100g,  double? densityGMl)  $default,) {final _that = this;
switch (_that) {
case _Food():
return $default(_that.id,_that.name,_that.updatedAt,_that.aliases,_that.category,_that.kcal100g,_that.protein100g,_that.carbs100g,_that.fat100g,_that.fibre100g,_that.sugar100g,_that.sodiumMg100g,_that.densityGMl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  DateTime updatedAt,  List<String> aliases,  String? category, @JsonKey(name: 'kcal_100g')  double kcal100g, @JsonKey(name: 'protein_100g')  double protein100g, @JsonKey(name: 'carbs_100g')  double carbs100g, @JsonKey(name: 'fat_100g')  double fat100g, @JsonKey(name: 'fibre_100g')  double fibre100g, @JsonKey(name: 'sugar_100g')  double? sugar100g, @JsonKey(name: 'sodium_mg_100g')  double? sodiumMg100g,  double? densityGMl)?  $default,) {final _that = this;
switch (_that) {
case _Food() when $default != null:
return $default(_that.id,_that.name,_that.updatedAt,_that.aliases,_that.category,_that.kcal100g,_that.protein100g,_that.carbs100g,_that.fat100g,_that.fibre100g,_that.sugar100g,_that.sodiumMg100g,_that.densityGMl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Food implements Food {
  const _Food({required this.id, required this.name, required this.updatedAt,  List<String> aliases = const <String>[], this.category, @JsonKey(name: 'kcal_100g') this.kcal100g = 0, @JsonKey(name: 'protein_100g') this.protein100g = 0, @JsonKey(name: 'carbs_100g') this.carbs100g = 0, @JsonKey(name: 'fat_100g') this.fat100g = 0, @JsonKey(name: 'fibre_100g') this.fibre100g = 0, @JsonKey(name: 'sugar_100g') this.sugar100g, @JsonKey(name: 'sodium_mg_100g') this.sodiumMg100g, this.densityGMl}): _aliases = aliases;
  factory _Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

@override final  String id;
@override final  String name;
@override final  DateTime updatedAt;
 final  List<String> _aliases;
@override@JsonKey() List<String> get aliases {
  if (_aliases is EqualUnmodifiableListView) return _aliases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aliases);
}

@override final  String? category;
@override@JsonKey(name: 'kcal_100g') final  double kcal100g;
@override@JsonKey(name: 'protein_100g') final  double protein100g;
@override@JsonKey(name: 'carbs_100g') final  double carbs100g;
@override@JsonKey(name: 'fat_100g') final  double fat100g;
@override@JsonKey(name: 'fibre_100g') final  double fibre100g;
@override@JsonKey(name: 'sugar_100g') final  double? sugar100g;
@override@JsonKey(name: 'sodium_mg_100g') final  double? sodiumMg100g;
@override final  double? densityGMl;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCopyWith<_Food> get copyWith => __$FoodCopyWithImpl<_Food>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Food&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.aliases, _aliases)&&(identical(other.category, category) || other.category == category)&&(identical(other.kcal100g, kcal100g) || other.kcal100g == kcal100g)&&(identical(other.protein100g, protein100g) || other.protein100g == protein100g)&&(identical(other.carbs100g, carbs100g) || other.carbs100g == carbs100g)&&(identical(other.fat100g, fat100g) || other.fat100g == fat100g)&&(identical(other.fibre100g, fibre100g) || other.fibre100g == fibre100g)&&(identical(other.sugar100g, sugar100g) || other.sugar100g == sugar100g)&&(identical(other.sodiumMg100g, sodiumMg100g) || other.sodiumMg100g == sodiumMg100g)&&(identical(other.densityGMl, densityGMl) || other.densityGMl == densityGMl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,updatedAt,const DeepCollectionEquality().hash(_aliases),category,kcal100g,protein100g,carbs100g,fat100g,fibre100g,sugar100g,sodiumMg100g,densityGMl);
}

@override
String toString() {
    return 'Food(id: $id, name: $name, updatedAt: $updatedAt, aliases: $aliases, category: $category, kcal100g: $kcal100g, protein100g: $protein100g, carbs100g: $carbs100g, fat100g: $fat100g, fibre100g: $fibre100g, sugar100g: $sugar100g, sodiumMg100g: $sodiumMg100g, densityGMl: $densityGMl)';
}


}

/// @nodoc
abstract mixin class _$FoodCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$FoodCopyWith(_Food value, $Res Function(_Food) _then) = __$FoodCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, DateTime updatedAt, List<String> aliases, String? category,@JsonKey(name: 'kcal_100g') double kcal100g,@JsonKey(name: 'protein_100g') double protein100g,@JsonKey(name: 'carbs_100g') double carbs100g,@JsonKey(name: 'fat_100g') double fat100g,@JsonKey(name: 'fibre_100g') double fibre100g,@JsonKey(name: 'sugar_100g') double? sugar100g,@JsonKey(name: 'sodium_mg_100g') double? sodiumMg100g, double? densityGMl
});




}
/// @nodoc
class __$FoodCopyWithImpl<$Res>
    implements _$FoodCopyWith<$Res> {
  __$FoodCopyWithImpl(this._self, this._then);

  final _Food _self;
  final $Res Function(_Food) _then;

/// Create a copy of Food
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? updatedAt = null,Object? aliases = null,Object? category = freezed,Object? kcal100g = null,Object? protein100g = null,Object? carbs100g = null,Object? fat100g = null,Object? fibre100g = null,Object? sugar100g = freezed,Object? sodiumMg100g = freezed,Object? densityGMl = freezed,}) {
  return _then(_Food(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,aliases: null == aliases ? _self._aliases : aliases // ignore: cast_nullable_to_non_nullable
as List<String>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,kcal100g: null == kcal100g ? _self.kcal100g : kcal100g // ignore: cast_nullable_to_non_nullable
as double,protein100g: null == protein100g ? _self.protein100g : protein100g // ignore: cast_nullable_to_non_nullable
as double,carbs100g: null == carbs100g ? _self.carbs100g : carbs100g // ignore: cast_nullable_to_non_nullable
as double,fat100g: null == fat100g ? _self.fat100g : fat100g // ignore: cast_nullable_to_non_nullable
as double,fibre100g: null == fibre100g ? _self.fibre100g : fibre100g // ignore: cast_nullable_to_non_nullable
as double,sugar100g: freezed == sugar100g ? _self.sugar100g : sugar100g // ignore: cast_nullable_to_non_nullable
as double?,sodiumMg100g: freezed == sodiumMg100g ? _self.sodiumMg100g : sodiumMg100g // ignore: cast_nullable_to_non_nullable
as double?,densityGMl: freezed == densityGMl ? _self.densityGMl : densityGMl // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$FoodPortion {

 String get foodId; String get label; double get grams; DateTime get updatedAt; bool get isDefault;
/// Create a copy of FoodPortion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodPortionCopyWith<FoodPortion> get copyWith => _$FoodPortionCopyWithImpl<FoodPortion>(this as FoodPortion, _$identity);

  /// Serializes this FoodPortion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FoodPortion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodPortion&&(identical(other.foodId, _this.foodId) || other.foodId == _this.foodId)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.grams, _this.grams) || other.grams == _this.grams)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FoodPortion;
  return Object.hash(runtimeType,_this.foodId,_this.label,_this.grams,_this.updatedAt,_this.isDefault);
}

@override
String toString() {
  final _this = this as FoodPortion;
  return 'FoodPortion(foodId: ${_this.foodId}, label: ${_this.label}, grams: ${_this.grams}, updatedAt: ${_this.updatedAt}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $FoodPortionCopyWith<$Res>  {
  factory $FoodPortionCopyWith(FoodPortion value, $Res Function(FoodPortion) _then) = _$FoodPortionCopyWithImpl;
@useResult
$Res call({
 String foodId, String label, double grams, DateTime updatedAt, bool isDefault
});




}
/// @nodoc
class _$FoodPortionCopyWithImpl<$Res>
    implements $FoodPortionCopyWith<$Res> {
  _$FoodPortionCopyWithImpl(this._self, this._then);

  final FoodPortion _self;
  final $Res Function(FoodPortion) _then;

/// Create a copy of FoodPortion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodId = null,Object? label = null,Object? grams = null,Object? updatedAt = null,Object? isDefault = null,}) {
  return _then(FoodPortion(
foodId: null == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodPortion].
extension FoodPortionPatterns on FoodPortion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodPortion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodPortion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodPortion value)  $default,){
final _that = this;
switch (_that) {
case _FoodPortion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodPortion value)?  $default,){
final _that = this;
switch (_that) {
case _FoodPortion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String foodId,  String label,  double grams,  DateTime updatedAt,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodPortion() when $default != null:
return $default(_that.foodId,_that.label,_that.grams,_that.updatedAt,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String foodId,  String label,  double grams,  DateTime updatedAt,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _FoodPortion():
return $default(_that.foodId,_that.label,_that.grams,_that.updatedAt,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String foodId,  String label,  double grams,  DateTime updatedAt,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _FoodPortion() when $default != null:
return $default(_that.foodId,_that.label,_that.grams,_that.updatedAt,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodPortion implements FoodPortion {
  const _FoodPortion({required this.foodId, required this.label, required this.grams, required this.updatedAt, this.isDefault = false});
  factory _FoodPortion.fromJson(Map<String, dynamic> json) => _$FoodPortionFromJson(json);

@override final  String foodId;
@override final  String label;
@override final  double grams;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isDefault;

/// Create a copy of FoodPortion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodPortionCopyWith<_FoodPortion> get copyWith => __$FoodPortionCopyWithImpl<_FoodPortion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodPortionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodPortion&&(identical(other.foodId, foodId) || other.foodId == foodId)&&(identical(other.label, label) || other.label == label)&&(identical(other.grams, grams) || other.grams == grams)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,foodId,label,grams,updatedAt,isDefault);
}

@override
String toString() {
    return 'FoodPortion(foodId: $foodId, label: $label, grams: $grams, updatedAt: $updatedAt, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$FoodPortionCopyWith<$Res> implements $FoodPortionCopyWith<$Res> {
  factory _$FoodPortionCopyWith(_FoodPortion value, $Res Function(_FoodPortion) _then) = __$FoodPortionCopyWithImpl;
@override @useResult
$Res call({
 String foodId, String label, double grams, DateTime updatedAt, bool isDefault
});




}
/// @nodoc
class __$FoodPortionCopyWithImpl<$Res>
    implements _$FoodPortionCopyWith<$Res> {
  __$FoodPortionCopyWithImpl(this._self, this._then);

  final _FoodPortion _self;
  final $Res Function(_FoodPortion) _then;

/// Create a copy of FoodPortion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodId = null,Object? label = null,Object? grams = null,Object? updatedAt = null,Object? isDefault = null,}) {
  return _then(_FoodPortion(
foodId: null == foodId ? _self.foodId : foodId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,grams: null == grams ? _self.grams : grams // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
