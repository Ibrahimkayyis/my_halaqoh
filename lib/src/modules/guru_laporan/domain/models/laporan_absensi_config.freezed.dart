// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'laporan_absensi_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LaporanAbsensiConfig {

/// Student full name (from route param)
 String get santriName;/// Student NIS (from route param)
 String get santriNis;/// 'reguler' or 'takhassus' — drives session columns in the PDF
 String get programType;/// Halaqoh name (from HalaqohCubit)
 String get halaqohName;/// Teacher name (from HalaqohModel.guruNama)
 String get guruNama;/// The selected time range type
 ReportRange get range;/// Inclusive report start date (midnight)
 DateTime get startDate;/// Inclusive report end date (end of day)
 DateTime get endDate;
/// Create a copy of LaporanAbsensiConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaporanAbsensiConfigCopyWith<LaporanAbsensiConfig> get copyWith => _$LaporanAbsensiConfigCopyWithImpl<LaporanAbsensiConfig>(this as LaporanAbsensiConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaporanAbsensiConfig&&(identical(other.santriName, santriName) || other.santriName == santriName)&&(identical(other.santriNis, santriNis) || other.santriNis == santriNis)&&(identical(other.programType, programType) || other.programType == programType)&&(identical(other.halaqohName, halaqohName) || other.halaqohName == halaqohName)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.range, range) || other.range == range)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,santriName,santriNis,programType,halaqohName,guruNama,range,startDate,endDate);

@override
String toString() {
  return 'LaporanAbsensiConfig(santriName: $santriName, santriNis: $santriNis, programType: $programType, halaqohName: $halaqohName, guruNama: $guruNama, range: $range, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $LaporanAbsensiConfigCopyWith<$Res>  {
  factory $LaporanAbsensiConfigCopyWith(LaporanAbsensiConfig value, $Res Function(LaporanAbsensiConfig) _then) = _$LaporanAbsensiConfigCopyWithImpl;
@useResult
$Res call({
 String santriName, String santriNis, String programType, String halaqohName, String guruNama, ReportRange range, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$LaporanAbsensiConfigCopyWithImpl<$Res>
    implements $LaporanAbsensiConfigCopyWith<$Res> {
  _$LaporanAbsensiConfigCopyWithImpl(this._self, this._then);

  final LaporanAbsensiConfig _self;
  final $Res Function(LaporanAbsensiConfig) _then;

/// Create a copy of LaporanAbsensiConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? santriName = null,Object? santriNis = null,Object? programType = null,Object? halaqohName = null,Object? guruNama = null,Object? range = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
santriName: null == santriName ? _self.santriName : santriName // ignore: cast_nullable_to_non_nullable
as String,santriNis: null == santriNis ? _self.santriNis : santriNis // ignore: cast_nullable_to_non_nullable
as String,programType: null == programType ? _self.programType : programType // ignore: cast_nullable_to_non_nullable
as String,halaqohName: null == halaqohName ? _self.halaqohName : halaqohName // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ReportRange,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LaporanAbsensiConfig].
extension LaporanAbsensiConfigPatterns on LaporanAbsensiConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LaporanAbsensiConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LaporanAbsensiConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LaporanAbsensiConfig value)  $default,){
final _that = this;
switch (_that) {
case _LaporanAbsensiConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LaporanAbsensiConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LaporanAbsensiConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String santriName,  String santriNis,  String programType,  String halaqohName,  String guruNama,  ReportRange range,  DateTime startDate,  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LaporanAbsensiConfig() when $default != null:
return $default(_that.santriName,_that.santriNis,_that.programType,_that.halaqohName,_that.guruNama,_that.range,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String santriName,  String santriNis,  String programType,  String halaqohName,  String guruNama,  ReportRange range,  DateTime startDate,  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _LaporanAbsensiConfig():
return $default(_that.santriName,_that.santriNis,_that.programType,_that.halaqohName,_that.guruNama,_that.range,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String santriName,  String santriNis,  String programType,  String halaqohName,  String guruNama,  ReportRange range,  DateTime startDate,  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _LaporanAbsensiConfig() when $default != null:
return $default(_that.santriName,_that.santriNis,_that.programType,_that.halaqohName,_that.guruNama,_that.range,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _LaporanAbsensiConfig implements LaporanAbsensiConfig {
  const _LaporanAbsensiConfig({required this.santriName, required this.santriNis, required this.programType, required this.halaqohName, required this.guruNama, required this.range, required this.startDate, required this.endDate});
  

/// Student full name (from route param)
@override final  String santriName;
/// Student NIS (from route param)
@override final  String santriNis;
/// 'reguler' or 'takhassus' — drives session columns in the PDF
@override final  String programType;
/// Halaqoh name (from HalaqohCubit)
@override final  String halaqohName;
/// Teacher name (from HalaqohModel.guruNama)
@override final  String guruNama;
/// The selected time range type
@override final  ReportRange range;
/// Inclusive report start date (midnight)
@override final  DateTime startDate;
/// Inclusive report end date (end of day)
@override final  DateTime endDate;

/// Create a copy of LaporanAbsensiConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaporanAbsensiConfigCopyWith<_LaporanAbsensiConfig> get copyWith => __$LaporanAbsensiConfigCopyWithImpl<_LaporanAbsensiConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaporanAbsensiConfig&&(identical(other.santriName, santriName) || other.santriName == santriName)&&(identical(other.santriNis, santriNis) || other.santriNis == santriNis)&&(identical(other.programType, programType) || other.programType == programType)&&(identical(other.halaqohName, halaqohName) || other.halaqohName == halaqohName)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.range, range) || other.range == range)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,santriName,santriNis,programType,halaqohName,guruNama,range,startDate,endDate);

@override
String toString() {
  return 'LaporanAbsensiConfig(santriName: $santriName, santriNis: $santriNis, programType: $programType, halaqohName: $halaqohName, guruNama: $guruNama, range: $range, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$LaporanAbsensiConfigCopyWith<$Res> implements $LaporanAbsensiConfigCopyWith<$Res> {
  factory _$LaporanAbsensiConfigCopyWith(_LaporanAbsensiConfig value, $Res Function(_LaporanAbsensiConfig) _then) = __$LaporanAbsensiConfigCopyWithImpl;
@override @useResult
$Res call({
 String santriName, String santriNis, String programType, String halaqohName, String guruNama, ReportRange range, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class __$LaporanAbsensiConfigCopyWithImpl<$Res>
    implements _$LaporanAbsensiConfigCopyWith<$Res> {
  __$LaporanAbsensiConfigCopyWithImpl(this._self, this._then);

  final _LaporanAbsensiConfig _self;
  final $Res Function(_LaporanAbsensiConfig) _then;

/// Create a copy of LaporanAbsensiConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? santriName = null,Object? santriNis = null,Object? programType = null,Object? halaqohName = null,Object? guruNama = null,Object? range = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_LaporanAbsensiConfig(
santriName: null == santriName ? _self.santriName : santriName // ignore: cast_nullable_to_non_nullable
as String,santriNis: null == santriNis ? _self.santriNis : santriNis // ignore: cast_nullable_to_non_nullable
as String,programType: null == programType ? _self.programType : programType // ignore: cast_nullable_to_non_nullable
as String,halaqohName: null == halaqohName ? _self.halaqohName : halaqohName // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ReportRange,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
