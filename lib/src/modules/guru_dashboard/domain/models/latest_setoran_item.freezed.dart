// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'latest_setoran_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LatestSetoranItem {

/// Student full name (resolved from SantriCubit)
 String get santriName;/// Surah info string, e.g. "Al-Mulk 1 - 9"
 String get surahInfo;/// Kelancaran score
 int get score;
/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestSetoranItemCopyWith<LatestSetoranItem> get copyWith => _$LatestSetoranItemCopyWithImpl<LatestSetoranItem>(this as LatestSetoranItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestSetoranItem&&(identical(other.santriName, santriName) || other.santriName == santriName)&&(identical(other.surahInfo, surahInfo) || other.surahInfo == surahInfo)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,santriName,surahInfo,score);

@override
String toString() {
  return 'LatestSetoranItem(santriName: $santriName, surahInfo: $surahInfo, score: $score)';
}


}

/// @nodoc
abstract mixin class $LatestSetoranItemCopyWith<$Res>  {
  factory $LatestSetoranItemCopyWith(LatestSetoranItem value, $Res Function(LatestSetoranItem) _then) = _$LatestSetoranItemCopyWithImpl;
@useResult
$Res call({
 String santriName, String surahInfo, int score
});




}
/// @nodoc
class _$LatestSetoranItemCopyWithImpl<$Res>
    implements $LatestSetoranItemCopyWith<$Res> {
  _$LatestSetoranItemCopyWithImpl(this._self, this._then);

  final LatestSetoranItem _self;
  final $Res Function(LatestSetoranItem) _then;

/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? santriName = null,Object? surahInfo = null,Object? score = null,}) {
  return _then(_self.copyWith(
santriName: null == santriName ? _self.santriName : santriName // ignore: cast_nullable_to_non_nullable
as String,surahInfo: null == surahInfo ? _self.surahInfo : surahInfo // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LatestSetoranItem].
extension LatestSetoranItemPatterns on LatestSetoranItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LatestSetoranItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LatestSetoranItem value)  $default,){
final _that = this;
switch (_that) {
case _LatestSetoranItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LatestSetoranItem value)?  $default,){
final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String santriName,  String surahInfo,  int score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
return $default(_that.santriName,_that.surahInfo,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String santriName,  String surahInfo,  int score)  $default,) {final _that = this;
switch (_that) {
case _LatestSetoranItem():
return $default(_that.santriName,_that.surahInfo,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String santriName,  String surahInfo,  int score)?  $default,) {final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
return $default(_that.santriName,_that.surahInfo,_that.score);case _:
  return null;

}
}

}

/// @nodoc


class _LatestSetoranItem implements LatestSetoranItem {
  const _LatestSetoranItem({required this.santriName, required this.surahInfo, required this.score});
  

/// Student full name (resolved from SantriCubit)
@override final  String santriName;
/// Surah info string, e.g. "Al-Mulk 1 - 9"
@override final  String surahInfo;
/// Kelancaran score
@override final  int score;

/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatestSetoranItemCopyWith<_LatestSetoranItem> get copyWith => __$LatestSetoranItemCopyWithImpl<_LatestSetoranItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LatestSetoranItem&&(identical(other.santriName, santriName) || other.santriName == santriName)&&(identical(other.surahInfo, surahInfo) || other.surahInfo == surahInfo)&&(identical(other.score, score) || other.score == score));
}


@override
int get hashCode => Object.hash(runtimeType,santriName,surahInfo,score);

@override
String toString() {
  return 'LatestSetoranItem(santriName: $santriName, surahInfo: $surahInfo, score: $score)';
}


}

/// @nodoc
abstract mixin class _$LatestSetoranItemCopyWith<$Res> implements $LatestSetoranItemCopyWith<$Res> {
  factory _$LatestSetoranItemCopyWith(_LatestSetoranItem value, $Res Function(_LatestSetoranItem) _then) = __$LatestSetoranItemCopyWithImpl;
@override @useResult
$Res call({
 String santriName, String surahInfo, int score
});




}
/// @nodoc
class __$LatestSetoranItemCopyWithImpl<$Res>
    implements _$LatestSetoranItemCopyWith<$Res> {
  __$LatestSetoranItemCopyWithImpl(this._self, this._then);

  final _LatestSetoranItem _self;
  final $Res Function(_LatestSetoranItem) _then;

/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? santriName = null,Object? surahInfo = null,Object? score = null,}) {
  return _then(_LatestSetoranItem(
santriName: null == santriName ? _self.santriName : santriName // ignore: cast_nullable_to_non_nullable
as String,surahInfo: null == surahInfo ? _self.surahInfo : surahInfo // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
