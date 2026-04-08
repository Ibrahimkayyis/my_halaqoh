// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quran_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuranData {

 List<SurahModel> get surahs; List<JuzModel> get juz;
/// Create a copy of QuranData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuranDataCopyWith<QuranData> get copyWith => _$QuranDataCopyWithImpl<QuranData>(this as QuranData, _$identity);

  /// Serializes this QuranData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuranData&&const DeepCollectionEquality().equals(other.surahs, surahs)&&const DeepCollectionEquality().equals(other.juz, juz));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(surahs),const DeepCollectionEquality().hash(juz));

@override
String toString() {
  return 'QuranData(surahs: $surahs, juz: $juz)';
}


}

/// @nodoc
abstract mixin class $QuranDataCopyWith<$Res>  {
  factory $QuranDataCopyWith(QuranData value, $Res Function(QuranData) _then) = _$QuranDataCopyWithImpl;
@useResult
$Res call({
 List<SurahModel> surahs, List<JuzModel> juz
});




}
/// @nodoc
class _$QuranDataCopyWithImpl<$Res>
    implements $QuranDataCopyWith<$Res> {
  _$QuranDataCopyWithImpl(this._self, this._then);

  final QuranData _self;
  final $Res Function(QuranData) _then;

/// Create a copy of QuranData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surahs = null,Object? juz = null,}) {
  return _then(_self.copyWith(
surahs: null == surahs ? _self.surahs : surahs // ignore: cast_nullable_to_non_nullable
as List<SurahModel>,juz: null == juz ? _self.juz : juz // ignore: cast_nullable_to_non_nullable
as List<JuzModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuranData].
extension QuranDataPatterns on QuranData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuranData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuranData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuranData value)  $default,){
final _that = this;
switch (_that) {
case _QuranData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuranData value)?  $default,){
final _that = this;
switch (_that) {
case _QuranData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SurahModel> surahs,  List<JuzModel> juz)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuranData() when $default != null:
return $default(_that.surahs,_that.juz);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SurahModel> surahs,  List<JuzModel> juz)  $default,) {final _that = this;
switch (_that) {
case _QuranData():
return $default(_that.surahs,_that.juz);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SurahModel> surahs,  List<JuzModel> juz)?  $default,) {final _that = this;
switch (_that) {
case _QuranData() when $default != null:
return $default(_that.surahs,_that.juz);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuranData extends QuranData {
  const _QuranData({required final  List<SurahModel> surahs, required final  List<JuzModel> juz}): _surahs = surahs,_juz = juz,super._();
  factory _QuranData.fromJson(Map<String, dynamic> json) => _$QuranDataFromJson(json);

 final  List<SurahModel> _surahs;
@override List<SurahModel> get surahs {
  if (_surahs is EqualUnmodifiableListView) return _surahs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surahs);
}

 final  List<JuzModel> _juz;
@override List<JuzModel> get juz {
  if (_juz is EqualUnmodifiableListView) return _juz;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_juz);
}


/// Create a copy of QuranData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuranDataCopyWith<_QuranData> get copyWith => __$QuranDataCopyWithImpl<_QuranData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuranDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuranData&&const DeepCollectionEquality().equals(other._surahs, _surahs)&&const DeepCollectionEquality().equals(other._juz, _juz));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_surahs),const DeepCollectionEquality().hash(_juz));

@override
String toString() {
  return 'QuranData(surahs: $surahs, juz: $juz)';
}


}

/// @nodoc
abstract mixin class _$QuranDataCopyWith<$Res> implements $QuranDataCopyWith<$Res> {
  factory _$QuranDataCopyWith(_QuranData value, $Res Function(_QuranData) _then) = __$QuranDataCopyWithImpl;
@override @useResult
$Res call({
 List<SurahModel> surahs, List<JuzModel> juz
});




}
/// @nodoc
class __$QuranDataCopyWithImpl<$Res>
    implements _$QuranDataCopyWith<$Res> {
  __$QuranDataCopyWithImpl(this._self, this._then);

  final _QuranData _self;
  final $Res Function(_QuranData) _then;

/// Create a copy of QuranData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surahs = null,Object? juz = null,}) {
  return _then(_QuranData(
surahs: null == surahs ? _self._surahs : surahs // ignore: cast_nullable_to_non_nullable
as List<SurahModel>,juz: null == juz ? _self._juz : juz // ignore: cast_nullable_to_non_nullable
as List<JuzModel>,
  ));
}


}

// dart format on
