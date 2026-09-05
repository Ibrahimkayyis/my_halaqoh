// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'laporan_hafalan_halaqoh_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LaporanHafalanHalaqohConfig {

/// Name of the halaqoh (from HalaqohModel.nama)
 String get halaqohName;/// Teacher's full name (from HalaqohModel.guruNama)
 String get guruNama;/// Class name / level (from HalaqohModel.kelas)
 String get kelas;/// The selected time range type
 ReportRange get range;/// Inclusive report start date (midnight)
 DateTime get startDate;/// Inclusive report end date (end of day)
 DateTime get endDate;
/// Create a copy of LaporanHafalanHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaporanHafalanHalaqohConfigCopyWith<LaporanHafalanHalaqohConfig> get copyWith => _$LaporanHafalanHalaqohConfigCopyWithImpl<LaporanHafalanHalaqohConfig>(this as LaporanHafalanHalaqohConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaporanHafalanHalaqohConfig&&(identical(other.halaqohName, halaqohName) || other.halaqohName == halaqohName)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.range, range) || other.range == range)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,halaqohName,guruNama,kelas,range,startDate,endDate);

@override
String toString() {
  return 'LaporanHafalanHalaqohConfig(halaqohName: $halaqohName, guruNama: $guruNama, kelas: $kelas, range: $range, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $LaporanHafalanHalaqohConfigCopyWith<$Res>  {
  factory $LaporanHafalanHalaqohConfigCopyWith(LaporanHafalanHalaqohConfig value, $Res Function(LaporanHafalanHalaqohConfig) _then) = _$LaporanHafalanHalaqohConfigCopyWithImpl;
@useResult
$Res call({
 String halaqohName, String guruNama, String kelas, ReportRange range, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$LaporanHafalanHalaqohConfigCopyWithImpl<$Res>
    implements $LaporanHafalanHalaqohConfigCopyWith<$Res> {
  _$LaporanHafalanHalaqohConfigCopyWithImpl(this._self, this._then);

  final LaporanHafalanHalaqohConfig _self;
  final $Res Function(LaporanHafalanHalaqohConfig) _then;

/// Create a copy of LaporanHafalanHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? halaqohName = null,Object? guruNama = null,Object? kelas = null,Object? range = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
halaqohName: null == halaqohName ? _self.halaqohName : halaqohName // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ReportRange,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LaporanHafalanHalaqohConfig].
extension LaporanHafalanHalaqohConfigPatterns on LaporanHafalanHalaqohConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LaporanHafalanHalaqohConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LaporanHafalanHalaqohConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LaporanHafalanHalaqohConfig value)  $default,){
final _that = this;
switch (_that) {
case _LaporanHafalanHalaqohConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LaporanHafalanHalaqohConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LaporanHafalanHalaqohConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String halaqohName,  String guruNama,  String kelas,  ReportRange range,  DateTime startDate,  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LaporanHafalanHalaqohConfig() when $default != null:
return $default(_that.halaqohName,_that.guruNama,_that.kelas,_that.range,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String halaqohName,  String guruNama,  String kelas,  ReportRange range,  DateTime startDate,  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _LaporanHafalanHalaqohConfig():
return $default(_that.halaqohName,_that.guruNama,_that.kelas,_that.range,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String halaqohName,  String guruNama,  String kelas,  ReportRange range,  DateTime startDate,  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _LaporanHafalanHalaqohConfig() when $default != null:
return $default(_that.halaqohName,_that.guruNama,_that.kelas,_that.range,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _LaporanHafalanHalaqohConfig implements LaporanHafalanHalaqohConfig {
  const _LaporanHafalanHalaqohConfig({required this.halaqohName, required this.guruNama, required this.kelas, required this.range, required this.startDate, required this.endDate});
  

/// Name of the halaqoh (from HalaqohModel.nama)
@override final  String halaqohName;
/// Teacher's full name (from HalaqohModel.guruNama)
@override final  String guruNama;
/// Class name / level (from HalaqohModel.kelas)
@override final  String kelas;
/// The selected time range type
@override final  ReportRange range;
/// Inclusive report start date (midnight)
@override final  DateTime startDate;
/// Inclusive report end date (end of day)
@override final  DateTime endDate;

/// Create a copy of LaporanHafalanHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaporanHafalanHalaqohConfigCopyWith<_LaporanHafalanHalaqohConfig> get copyWith => __$LaporanHafalanHalaqohConfigCopyWithImpl<_LaporanHafalanHalaqohConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaporanHafalanHalaqohConfig&&(identical(other.halaqohName, halaqohName) || other.halaqohName == halaqohName)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.range, range) || other.range == range)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,halaqohName,guruNama,kelas,range,startDate,endDate);

@override
String toString() {
  return 'LaporanHafalanHalaqohConfig(halaqohName: $halaqohName, guruNama: $guruNama, kelas: $kelas, range: $range, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$LaporanHafalanHalaqohConfigCopyWith<$Res> implements $LaporanHafalanHalaqohConfigCopyWith<$Res> {
  factory _$LaporanHafalanHalaqohConfigCopyWith(_LaporanHafalanHalaqohConfig value, $Res Function(_LaporanHafalanHalaqohConfig) _then) = __$LaporanHafalanHalaqohConfigCopyWithImpl;
@override @useResult
$Res call({
 String halaqohName, String guruNama, String kelas, ReportRange range, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class __$LaporanHafalanHalaqohConfigCopyWithImpl<$Res>
    implements _$LaporanHafalanHalaqohConfigCopyWith<$Res> {
  __$LaporanHafalanHalaqohConfigCopyWithImpl(this._self, this._then);

  final _LaporanHafalanHalaqohConfig _self;
  final $Res Function(_LaporanHafalanHalaqohConfig) _then;

/// Create a copy of LaporanHafalanHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? halaqohName = null,Object? guruNama = null,Object? kelas = null,Object? range = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_LaporanHafalanHalaqohConfig(
halaqohName: null == halaqohName ? _self.halaqohName : halaqohName // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ReportRange,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
