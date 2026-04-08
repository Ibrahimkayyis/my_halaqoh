// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'juz_segment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JuzSegmentModel {

/// In SurahModel.juzMappings: the juz number.
/// In JuzModel.surahs: not used (use surahId instead).
 int get juz;/// In JuzModel.surahs: the surah ID.
/// In SurahModel.juzMappings: not used (use juz instead).
@JsonKey(name: 'surah_id') int get surahId;@JsonKey(name: 'ayat_start') int get ayatStart;@JsonKey(name: 'ayat_end') int get ayatEnd;
/// Create a copy of JuzSegmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JuzSegmentModelCopyWith<JuzSegmentModel> get copyWith => _$JuzSegmentModelCopyWithImpl<JuzSegmentModel>(this as JuzSegmentModel, _$identity);

  /// Serializes this JuzSegmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JuzSegmentModel&&(identical(other.juz, juz) || other.juz == juz)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.ayatStart, ayatStart) || other.ayatStart == ayatStart)&&(identical(other.ayatEnd, ayatEnd) || other.ayatEnd == ayatEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,juz,surahId,ayatStart,ayatEnd);

@override
String toString() {
  return 'JuzSegmentModel(juz: $juz, surahId: $surahId, ayatStart: $ayatStart, ayatEnd: $ayatEnd)';
}


}

/// @nodoc
abstract mixin class $JuzSegmentModelCopyWith<$Res>  {
  factory $JuzSegmentModelCopyWith(JuzSegmentModel value, $Res Function(JuzSegmentModel) _then) = _$JuzSegmentModelCopyWithImpl;
@useResult
$Res call({
 int juz,@JsonKey(name: 'surah_id') int surahId,@JsonKey(name: 'ayat_start') int ayatStart,@JsonKey(name: 'ayat_end') int ayatEnd
});




}
/// @nodoc
class _$JuzSegmentModelCopyWithImpl<$Res>
    implements $JuzSegmentModelCopyWith<$Res> {
  _$JuzSegmentModelCopyWithImpl(this._self, this._then);

  final JuzSegmentModel _self;
  final $Res Function(JuzSegmentModel) _then;

/// Create a copy of JuzSegmentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? juz = null,Object? surahId = null,Object? ayatStart = null,Object? ayatEnd = null,}) {
  return _then(_self.copyWith(
juz: null == juz ? _self.juz : juz // ignore: cast_nullable_to_non_nullable
as int,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,ayatStart: null == ayatStart ? _self.ayatStart : ayatStart // ignore: cast_nullable_to_non_nullable
as int,ayatEnd: null == ayatEnd ? _self.ayatEnd : ayatEnd // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JuzSegmentModel].
extension JuzSegmentModelPatterns on JuzSegmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JuzSegmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JuzSegmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JuzSegmentModel value)  $default,){
final _that = this;
switch (_that) {
case _JuzSegmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JuzSegmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _JuzSegmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int juz, @JsonKey(name: 'surah_id')  int surahId, @JsonKey(name: 'ayat_start')  int ayatStart, @JsonKey(name: 'ayat_end')  int ayatEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JuzSegmentModel() when $default != null:
return $default(_that.juz,_that.surahId,_that.ayatStart,_that.ayatEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int juz, @JsonKey(name: 'surah_id')  int surahId, @JsonKey(name: 'ayat_start')  int ayatStart, @JsonKey(name: 'ayat_end')  int ayatEnd)  $default,) {final _that = this;
switch (_that) {
case _JuzSegmentModel():
return $default(_that.juz,_that.surahId,_that.ayatStart,_that.ayatEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int juz, @JsonKey(name: 'surah_id')  int surahId, @JsonKey(name: 'ayat_start')  int ayatStart, @JsonKey(name: 'ayat_end')  int ayatEnd)?  $default,) {final _that = this;
switch (_that) {
case _JuzSegmentModel() when $default != null:
return $default(_that.juz,_that.surahId,_that.ayatStart,_that.ayatEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JuzSegmentModel implements JuzSegmentModel {
  const _JuzSegmentModel({this.juz = 0, @JsonKey(name: 'surah_id') this.surahId = 0, @JsonKey(name: 'ayat_start') required this.ayatStart, @JsonKey(name: 'ayat_end') required this.ayatEnd});
  factory _JuzSegmentModel.fromJson(Map<String, dynamic> json) => _$JuzSegmentModelFromJson(json);

/// In SurahModel.juzMappings: the juz number.
/// In JuzModel.surahs: not used (use surahId instead).
@override@JsonKey() final  int juz;
/// In JuzModel.surahs: the surah ID.
/// In SurahModel.juzMappings: not used (use juz instead).
@override@JsonKey(name: 'surah_id') final  int surahId;
@override@JsonKey(name: 'ayat_start') final  int ayatStart;
@override@JsonKey(name: 'ayat_end') final  int ayatEnd;

/// Create a copy of JuzSegmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JuzSegmentModelCopyWith<_JuzSegmentModel> get copyWith => __$JuzSegmentModelCopyWithImpl<_JuzSegmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JuzSegmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JuzSegmentModel&&(identical(other.juz, juz) || other.juz == juz)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.ayatStart, ayatStart) || other.ayatStart == ayatStart)&&(identical(other.ayatEnd, ayatEnd) || other.ayatEnd == ayatEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,juz,surahId,ayatStart,ayatEnd);

@override
String toString() {
  return 'JuzSegmentModel(juz: $juz, surahId: $surahId, ayatStart: $ayatStart, ayatEnd: $ayatEnd)';
}


}

/// @nodoc
abstract mixin class _$JuzSegmentModelCopyWith<$Res> implements $JuzSegmentModelCopyWith<$Res> {
  factory _$JuzSegmentModelCopyWith(_JuzSegmentModel value, $Res Function(_JuzSegmentModel) _then) = __$JuzSegmentModelCopyWithImpl;
@override @useResult
$Res call({
 int juz,@JsonKey(name: 'surah_id') int surahId,@JsonKey(name: 'ayat_start') int ayatStart,@JsonKey(name: 'ayat_end') int ayatEnd
});




}
/// @nodoc
class __$JuzSegmentModelCopyWithImpl<$Res>
    implements _$JuzSegmentModelCopyWith<$Res> {
  __$JuzSegmentModelCopyWithImpl(this._self, this._then);

  final _JuzSegmentModel _self;
  final $Res Function(_JuzSegmentModel) _then;

/// Create a copy of JuzSegmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? juz = null,Object? surahId = null,Object? ayatStart = null,Object? ayatEnd = null,}) {
  return _then(_JuzSegmentModel(
juz: null == juz ? _self.juz : juz // ignore: cast_nullable_to_non_nullable
as int,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,ayatStart: null == ayatStart ? _self.ayatStart : ayatStart // ignore: cast_nullable_to_non_nullable
as int,ayatEnd: null == ayatEnd ? _self.ayatEnd : ayatEnd // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
