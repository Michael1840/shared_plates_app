// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeCollection {

 String get id; String get slug; String get title; CollectionKind get kind; String? get subtitle; Map<String, dynamic> get filter; int get position; DateTime? get startsOn; DateTime? get endsOn;
/// Create a copy of RecipeCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCollectionCopyWith<RecipeCollection> get copyWith => _$RecipeCollectionCopyWithImpl<RecipeCollection>(this as RecipeCollection, _$identity);

  /// Serializes this RecipeCollection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecipeCollection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecipeCollection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.subtitle, _this.subtitle) || other.subtitle == _this.subtitle)&&const DeepCollectionEquality().equals(other.filter, _this.filter)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.startsOn, _this.startsOn) || other.startsOn == _this.startsOn)&&(identical(other.endsOn, _this.endsOn) || other.endsOn == _this.endsOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecipeCollection;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.title,_this.kind,_this.subtitle,const DeepCollectionEquality().hash(_this.filter),_this.position,_this.startsOn,_this.endsOn);
}

@override
String toString() {
  final _this = this as RecipeCollection;
  return 'RecipeCollection(id: ${_this.id}, slug: ${_this.slug}, title: ${_this.title}, kind: ${_this.kind}, subtitle: ${_this.subtitle}, filter: ${_this.filter}, position: ${_this.position}, startsOn: ${_this.startsOn}, endsOn: ${_this.endsOn})';
}


}

/// @nodoc
abstract mixin class $RecipeCollectionCopyWith<$Res>  {
  factory $RecipeCollectionCopyWith(RecipeCollection value, $Res Function(RecipeCollection) _then) = _$RecipeCollectionCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, CollectionKind kind, String? subtitle, Map<String, dynamic> filter, int position, DateTime? startsOn, DateTime? endsOn
});




}
/// @nodoc
class _$RecipeCollectionCopyWithImpl<$Res>
    implements $RecipeCollectionCopyWith<$Res> {
  _$RecipeCollectionCopyWithImpl(this._self, this._then);

  final RecipeCollection _self;
  final $Res Function(RecipeCollection) _then;

/// Create a copy of RecipeCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? kind = null,Object? subtitle = freezed,Object? filter = null,Object? position = null,Object? startsOn = freezed,Object? endsOn = freezed,}) {
  return _then(RecipeCollection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CollectionKind,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,startsOn: freezed == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endsOn: freezed == endsOn ? _self.endsOn : endsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecipeCollection].
extension RecipeCollectionPatterns on RecipeCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecipeCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecipeCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecipeCollection value)  $default,){
final _that = this;
switch (_that) {
case _RecipeCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecipeCollection value)?  $default,){
final _that = this;
switch (_that) {
case _RecipeCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  CollectionKind kind,  String? subtitle,  Map<String, dynamic> filter,  int position,  DateTime? startsOn,  DateTime? endsOn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecipeCollection() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.kind,_that.subtitle,_that.filter,_that.position,_that.startsOn,_that.endsOn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  CollectionKind kind,  String? subtitle,  Map<String, dynamic> filter,  int position,  DateTime? startsOn,  DateTime? endsOn)  $default,) {final _that = this;
switch (_that) {
case _RecipeCollection():
return $default(_that.id,_that.slug,_that.title,_that.kind,_that.subtitle,_that.filter,_that.position,_that.startsOn,_that.endsOn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  CollectionKind kind,  String? subtitle,  Map<String, dynamic> filter,  int position,  DateTime? startsOn,  DateTime? endsOn)?  $default,) {final _that = this;
switch (_that) {
case _RecipeCollection() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.kind,_that.subtitle,_that.filter,_that.position,_that.startsOn,_that.endsOn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecipeCollection extends RecipeCollection {
  const _RecipeCollection({required this.id, required this.slug, required this.title, required this.kind, this.subtitle,  Map<String, dynamic> filter = const <String, dynamic>{}, this.position = 0, this.startsOn, this.endsOn}): _filter = filter,super._();
  factory _RecipeCollection.fromJson(Map<String, dynamic> json) => _$RecipeCollectionFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  CollectionKind kind;
@override final  String? subtitle;
 final  Map<String, dynamic> _filter;
@override@JsonKey() Map<String, dynamic> get filter {
  if (_filter is EqualUnmodifiableMapView) return _filter;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_filter);
}

@override@JsonKey() final  int position;
@override final  DateTime? startsOn;
@override final  DateTime? endsOn;

/// Create a copy of RecipeCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCollectionCopyWith<_RecipeCollection> get copyWith => __$RecipeCollectionCopyWithImpl<_RecipeCollection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeCollectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecipeCollection&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.filter, _filter)&&(identical(other.position, position) || other.position == position)&&(identical(other.startsOn, startsOn) || other.startsOn == startsOn)&&(identical(other.endsOn, endsOn) || other.endsOn == endsOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,title,kind,subtitle,const DeepCollectionEquality().hash(_filter),position,startsOn,endsOn);
}

@override
String toString() {
    return 'RecipeCollection(id: $id, slug: $slug, title: $title, kind: $kind, subtitle: $subtitle, filter: $filter, position: $position, startsOn: $startsOn, endsOn: $endsOn)';
}


}

/// @nodoc
abstract mixin class _$RecipeCollectionCopyWith<$Res> implements $RecipeCollectionCopyWith<$Res> {
  factory _$RecipeCollectionCopyWith(_RecipeCollection value, $Res Function(_RecipeCollection) _then) = __$RecipeCollectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, CollectionKind kind, String? subtitle, Map<String, dynamic> filter, int position, DateTime? startsOn, DateTime? endsOn
});




}
/// @nodoc
class __$RecipeCollectionCopyWithImpl<$Res>
    implements _$RecipeCollectionCopyWith<$Res> {
  __$RecipeCollectionCopyWithImpl(this._self, this._then);

  final _RecipeCollection _self;
  final $Res Function(_RecipeCollection) _then;

/// Create a copy of RecipeCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? kind = null,Object? subtitle = freezed,Object? filter = null,Object? position = null,Object? startsOn = freezed,Object? endsOn = freezed,}) {
  return _then(_RecipeCollection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as CollectionKind,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,filter: null == filter ? _self._filter : filter // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,startsOn: freezed == startsOn ? _self.startsOn : startsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,endsOn: freezed == endsOn ? _self.endsOn : endsOn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
