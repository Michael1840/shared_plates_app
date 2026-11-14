// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_cook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PopularCook {

 String get id; String get username; String get displayName; String? get avatarPath; int get recipes; int get saves;
/// Create a copy of PopularCook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopularCookCopyWith<PopularCook> get copyWith => _$PopularCookCopyWithImpl<PopularCook>(this as PopularCook, _$identity);

  /// Serializes this PopularCook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PopularCook;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopularCook&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.avatarPath, _this.avatarPath) || other.avatarPath == _this.avatarPath)&&(identical(other.recipes, _this.recipes) || other.recipes == _this.recipes)&&(identical(other.saves, _this.saves) || other.saves == _this.saves));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PopularCook;
  return Object.hash(runtimeType,_this.id,_this.username,_this.displayName,_this.avatarPath,_this.recipes,_this.saves);
}

@override
String toString() {
  final _this = this as PopularCook;
  return 'PopularCook(id: ${_this.id}, username: ${_this.username}, displayName: ${_this.displayName}, avatarPath: ${_this.avatarPath}, recipes: ${_this.recipes}, saves: ${_this.saves})';
}


}

/// @nodoc
abstract mixin class $PopularCookCopyWith<$Res>  {
  factory $PopularCookCopyWith(PopularCook value, $Res Function(PopularCook) _then) = _$PopularCookCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, String? avatarPath, int recipes, int saves
});




}
/// @nodoc
class _$PopularCookCopyWithImpl<$Res>
    implements $PopularCookCopyWith<$Res> {
  _$PopularCookCopyWithImpl(this._self, this._then);

  final PopularCook _self;
  final $Res Function(PopularCook) _then;

/// Create a copy of PopularCook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarPath = freezed,Object? recipes = null,Object? saves = null,}) {
  return _then(PopularCook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,recipes: null == recipes ? _self.recipes : recipes // ignore: cast_nullable_to_non_nullable
as int,saves: null == saves ? _self.saves : saves // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PopularCook].
extension PopularCookPatterns on PopularCook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PopularCook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PopularCook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PopularCook value)  $default,){
final _that = this;
switch (_that) {
case _PopularCook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PopularCook value)?  $default,){
final _that = this;
switch (_that) {
case _PopularCook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? avatarPath,  int recipes,  int saves)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PopularCook() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarPath,_that.recipes,_that.saves);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? avatarPath,  int recipes,  int saves)  $default,) {final _that = this;
switch (_that) {
case _PopularCook():
return $default(_that.id,_that.username,_that.displayName,_that.avatarPath,_that.recipes,_that.saves);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  String? avatarPath,  int recipes,  int saves)?  $default,) {final _that = this;
switch (_that) {
case _PopularCook() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.avatarPath,_that.recipes,_that.saves);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PopularCook extends PopularCook {
  const _PopularCook({required this.id, required this.username, required this.displayName, this.avatarPath, this.recipes = 0, this.saves = 0}): super._();
  factory _PopularCook.fromJson(Map<String, dynamic> json) => _$PopularCookFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  String? avatarPath;
@override@JsonKey() final  int recipes;
@override@JsonKey() final  int saves;

/// Create a copy of PopularCook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopularCookCopyWith<_PopularCook> get copyWith => __$PopularCookCopyWithImpl<_PopularCook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PopularCookToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PopularCook&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarPath, avatarPath) || other.avatarPath == avatarPath)&&(identical(other.recipes, recipes) || other.recipes == recipes)&&(identical(other.saves, saves) || other.saves == saves));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,displayName,avatarPath,recipes,saves);
}

@override
String toString() {
    return 'PopularCook(id: $id, username: $username, displayName: $displayName, avatarPath: $avatarPath, recipes: $recipes, saves: $saves)';
}


}

/// @nodoc
abstract mixin class _$PopularCookCopyWith<$Res> implements $PopularCookCopyWith<$Res> {
  factory _$PopularCookCopyWith(_PopularCook value, $Res Function(_PopularCook) _then) = __$PopularCookCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, String? avatarPath, int recipes, int saves
});




}
/// @nodoc
class __$PopularCookCopyWithImpl<$Res>
    implements _$PopularCookCopyWith<$Res> {
  __$PopularCookCopyWithImpl(this._self, this._then);

  final _PopularCook _self;
  final $Res Function(_PopularCook) _then;

/// Create a copy of PopularCook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? avatarPath = freezed,Object? recipes = null,Object? saves = null,}) {
  return _then(_PopularCook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,recipes: null == recipes ? _self.recipes : recipes // ignore: cast_nullable_to_non_nullable
as int,saves: null == saves ? _self.saves : saves // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
