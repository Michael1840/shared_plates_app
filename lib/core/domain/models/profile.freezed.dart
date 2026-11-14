// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get id; String get username; String get displayName; DateTime get createdAt; DateTime get updatedAt; String? get avatarPath; String? get bio; String? get city; UnitSystem get units; String get currency; RecipeVisibility get defaultVisibility; bool get keepScreenOn; bool get notifySaves; bool get notifyCooks; bool get notifyFriends; bool get weeklyRoundup; DateTime? get onboardedAt;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Profile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.avatarPath, _this.avatarPath) || other.avatarPath == _this.avatarPath)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.units, _this.units) || other.units == _this.units)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.defaultVisibility, _this.defaultVisibility) || other.defaultVisibility == _this.defaultVisibility)&&(identical(other.keepScreenOn, _this.keepScreenOn) || other.keepScreenOn == _this.keepScreenOn)&&(identical(other.notifySaves, _this.notifySaves) || other.notifySaves == _this.notifySaves)&&(identical(other.notifyCooks, _this.notifyCooks) || other.notifyCooks == _this.notifyCooks)&&(identical(other.notifyFriends, _this.notifyFriends) || other.notifyFriends == _this.notifyFriends)&&(identical(other.weeklyRoundup, _this.weeklyRoundup) || other.weeklyRoundup == _this.weeklyRoundup)&&(identical(other.onboardedAt, _this.onboardedAt) || other.onboardedAt == _this.onboardedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Profile;
  return Object.hash(runtimeType,_this.id,_this.username,_this.displayName,_this.createdAt,_this.updatedAt,_this.avatarPath,_this.bio,_this.city,_this.units,_this.currency,_this.defaultVisibility,_this.keepScreenOn,_this.notifySaves,_this.notifyCooks,_this.notifyFriends,_this.weeklyRoundup,_this.onboardedAt);
}

@override
String toString() {
  final _this = this as Profile;
  return 'Profile(id: ${_this.id}, username: ${_this.username}, displayName: ${_this.displayName}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, avatarPath: ${_this.avatarPath}, bio: ${_this.bio}, city: ${_this.city}, units: ${_this.units}, currency: ${_this.currency}, defaultVisibility: ${_this.defaultVisibility}, keepScreenOn: ${_this.keepScreenOn}, notifySaves: ${_this.notifySaves}, notifyCooks: ${_this.notifyCooks}, notifyFriends: ${_this.notifyFriends}, weeklyRoundup: ${_this.weeklyRoundup}, onboardedAt: ${_this.onboardedAt})';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, DateTime createdAt, DateTime updatedAt, String? avatarPath, String? bio, String? city, UnitSystem units, String currency, RecipeVisibility defaultVisibility, bool keepScreenOn, bool notifySaves, bool notifyCooks, bool notifyFriends, bool weeklyRoundup, DateTime? onboardedAt
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? createdAt = null,Object? updatedAt = null,Object? avatarPath = freezed,Object? bio = freezed,Object? city = freezed,Object? units = null,Object? currency = null,Object? defaultVisibility = null,Object? keepScreenOn = null,Object? notifySaves = null,Object? notifyCooks = null,Object? notifyFriends = null,Object? weeklyRoundup = null,Object? onboardedAt = freezed,}) {
  return _then(Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as RecipeVisibility,keepScreenOn: null == keepScreenOn ? _self.keepScreenOn : keepScreenOn // ignore: cast_nullable_to_non_nullable
as bool,notifySaves: null == notifySaves ? _self.notifySaves : notifySaves // ignore: cast_nullable_to_non_nullable
as bool,notifyCooks: null == notifyCooks ? _self.notifyCooks : notifyCooks // ignore: cast_nullable_to_non_nullable
as bool,notifyFriends: null == notifyFriends ? _self.notifyFriends : notifyFriends // ignore: cast_nullable_to_non_nullable
as bool,weeklyRoundup: null == weeklyRoundup ? _self.weeklyRoundup : weeklyRoundup // ignore: cast_nullable_to_non_nullable
as bool,onboardedAt: freezed == onboardedAt ? _self.onboardedAt : onboardedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  DateTime createdAt,  DateTime updatedAt,  String? avatarPath,  String? bio,  String? city,  UnitSystem units,  String currency,  RecipeVisibility defaultVisibility,  bool keepScreenOn,  bool notifySaves,  bool notifyCooks,  bool notifyFriends,  bool weeklyRoundup,  DateTime? onboardedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.createdAt,_that.updatedAt,_that.avatarPath,_that.bio,_that.city,_that.units,_that.currency,_that.defaultVisibility,_that.keepScreenOn,_that.notifySaves,_that.notifyCooks,_that.notifyFriends,_that.weeklyRoundup,_that.onboardedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  DateTime createdAt,  DateTime updatedAt,  String? avatarPath,  String? bio,  String? city,  UnitSystem units,  String currency,  RecipeVisibility defaultVisibility,  bool keepScreenOn,  bool notifySaves,  bool notifyCooks,  bool notifyFriends,  bool weeklyRoundup,  DateTime? onboardedAt)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.username,_that.displayName,_that.createdAt,_that.updatedAt,_that.avatarPath,_that.bio,_that.city,_that.units,_that.currency,_that.defaultVisibility,_that.keepScreenOn,_that.notifySaves,_that.notifyCooks,_that.notifyFriends,_that.weeklyRoundup,_that.onboardedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  DateTime createdAt,  DateTime updatedAt,  String? avatarPath,  String? bio,  String? city,  UnitSystem units,  String currency,  RecipeVisibility defaultVisibility,  bool keepScreenOn,  bool notifySaves,  bool notifyCooks,  bool notifyFriends,  bool weeklyRoundup,  DateTime? onboardedAt)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.createdAt,_that.updatedAt,_that.avatarPath,_that.bio,_that.city,_that.units,_that.currency,_that.defaultVisibility,_that.keepScreenOn,_that.notifySaves,_that.notifyCooks,_that.notifyFriends,_that.weeklyRoundup,_that.onboardedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.id, required this.username, required this.displayName, required this.createdAt, required this.updatedAt, this.avatarPath, this.bio, this.city, this.units = UnitSystem.metric, this.currency = 'ZAR', this.defaultVisibility = RecipeVisibility.friends, this.keepScreenOn = true, this.notifySaves = true, this.notifyCooks = true, this.notifyFriends = true, this.weeklyRoundup = true, this.onboardedAt});
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? avatarPath;
@override final  String? bio;
@override final  String? city;
@override@JsonKey() final  UnitSystem units;
@override@JsonKey() final  String currency;
@override@JsonKey() final  RecipeVisibility defaultVisibility;
@override@JsonKey() final  bool keepScreenOn;
@override@JsonKey() final  bool notifySaves;
@override@JsonKey() final  bool notifyCooks;
@override@JsonKey() final  bool notifyFriends;
@override@JsonKey() final  bool weeklyRoundup;
@override final  DateTime? onboardedAt;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.avatarPath, avatarPath) || other.avatarPath == avatarPath)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.city, city) || other.city == city)&&(identical(other.units, units) || other.units == units)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.defaultVisibility, defaultVisibility) || other.defaultVisibility == defaultVisibility)&&(identical(other.keepScreenOn, keepScreenOn) || other.keepScreenOn == keepScreenOn)&&(identical(other.notifySaves, notifySaves) || other.notifySaves == notifySaves)&&(identical(other.notifyCooks, notifyCooks) || other.notifyCooks == notifyCooks)&&(identical(other.notifyFriends, notifyFriends) || other.notifyFriends == notifyFriends)&&(identical(other.weeklyRoundup, weeklyRoundup) || other.weeklyRoundup == weeklyRoundup)&&(identical(other.onboardedAt, onboardedAt) || other.onboardedAt == onboardedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,username,displayName,createdAt,updatedAt,avatarPath,bio,city,units,currency,defaultVisibility,keepScreenOn,notifySaves,notifyCooks,notifyFriends,weeklyRoundup,onboardedAt);
}

@override
String toString() {
    return 'Profile(id: $id, username: $username, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, avatarPath: $avatarPath, bio: $bio, city: $city, units: $units, currency: $currency, defaultVisibility: $defaultVisibility, keepScreenOn: $keepScreenOn, notifySaves: $notifySaves, notifyCooks: $notifyCooks, notifyFriends: $notifyFriends, weeklyRoundup: $weeklyRoundup, onboardedAt: $onboardedAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, DateTime createdAt, DateTime updatedAt, String? avatarPath, String? bio, String? city, UnitSystem units, String currency, RecipeVisibility defaultVisibility, bool keepScreenOn, bool notifySaves, bool notifyCooks, bool notifyFriends, bool weeklyRoundup, DateTime? onboardedAt
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? createdAt = null,Object? updatedAt = null,Object? avatarPath = freezed,Object? bio = freezed,Object? city = freezed,Object? units = null,Object? currency = null,Object? defaultVisibility = null,Object? keepScreenOn = null,Object? notifySaves = null,Object? notifyCooks = null,Object? notifyFriends = null,Object? weeklyRoundup = null,Object? onboardedAt = freezed,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,avatarPath: freezed == avatarPath ? _self.avatarPath : avatarPath // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as UnitSystem,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,defaultVisibility: null == defaultVisibility ? _self.defaultVisibility : defaultVisibility // ignore: cast_nullable_to_non_nullable
as RecipeVisibility,keepScreenOn: null == keepScreenOn ? _self.keepScreenOn : keepScreenOn // ignore: cast_nullable_to_non_nullable
as bool,notifySaves: null == notifySaves ? _self.notifySaves : notifySaves // ignore: cast_nullable_to_non_nullable
as bool,notifyCooks: null == notifyCooks ? _self.notifyCooks : notifyCooks // ignore: cast_nullable_to_non_nullable
as bool,notifyFriends: null == notifyFriends ? _self.notifyFriends : notifyFriends // ignore: cast_nullable_to_non_nullable
as bool,weeklyRoundup: null == weeklyRoundup ? _self.weeklyRoundup : weeklyRoundup // ignore: cast_nullable_to_non_nullable
as bool,onboardedAt: freezed == onboardedAt ? _self.onboardedAt : onboardedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
