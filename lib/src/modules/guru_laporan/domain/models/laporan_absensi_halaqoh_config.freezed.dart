// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'laporan_absensi_halaqoh_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LaporanAbsensiHalaqohConfig {

/// Name of the halaqoh (from HalaqohModel.nama)
 String get halaqohName;/// Teacher's full name (from HalaqohModel.guruNama)
 String get guruNama;/// 'reguler' | 'takhassus' — determines session columns & page orientation
 String get programType;/// The teacher-selected range type
 ReportRange get range;/// Inclusive report start date (midnight)
 DateTime get startDate;/// Inclusive report end date (end of day)
 DateTime get endDate;
/// Create a copy of LaporanAbsensiHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaporanAbsensiHalaqohConfigCopyWith<LaporanAbsensiHalaqohConfig> get copyWith => _$LaporanAbsensiHalaqohConfigCopyWithImpl<LaporanAbsensiHalaqohConfig>(this as LaporanAbsensiHalaqohConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaporanAbsensiHalaqohConfig&&(identical(other.halaqohName, halaqohName) || other.halaqohName == halaqohName)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.programType, programType) || other.programType == programType)&&(identical(other.range, range) || other.range == range)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,halaqohName,guruNama,programType,range,startDate,endDate);

@override
String toString() {
  return 'LaporanAbsensiHalaqohConfig(halaqohName: $halaqohName, guruNama: $guruNama, programType: $programType, range: $range, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $LaporanAbsensiHalaqohConfigCopyWith<$Res>  {
  factory $LaporanAbsensiHalaqohConfigCopyWith(LaporanAbsensiHalaqohConfig value, $Res Function(LaporanAbsensiHalaqohConfig) _then) = _$LaporanAbsensiHalaqohConfigCopyWithImpl;
@useResult
$Res call({
 String halaqohName, String guruNama, String programType, ReportRange range, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class _$LaporanAbsensiHalaqohConfigCopyWithImpl<$Res>
    implements $LaporanAbsensiHalaqohConfigCopyWith<$Res> {
  _$LaporanAbsensiHalaqohConfigCopyWithImpl(this._self, this._then);

  final LaporanAbsensiHalaqohConfig _self;
  final $Res Function(LaporanAbsensiHalaqohConfig) _then;

/// Create a copy of LaporanAbsensiHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? halaqohName = null,Object? guruNama = null,Object? programType = null,Object? range = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
halaqohName: null == halaqohName ? _self.halaqohName : halaqohName // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,programType: null == programType ? _self.programType : programType // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ReportRange,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LaporanAbsensiHalaqohConfig].
extension LaporanAbsensiHalaqohConfigPatterns on LaporanAbsensiHalaqohConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LaporanAbsensiHalaqohConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LaporanAbsensiHalaqohConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LaporanAbsensiHalaqohConfig value)  $default,){
final _that = this;
switch (_that) {
case _LaporanAbsensiHalaqohConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LaporanAbsensiHalaqohConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LaporanAbsensiHalaqohConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String halaqohName,  String guruNama,  String programType,  ReportRange range,  DateTime startDate,  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LaporanAbsensiHalaqohConfig() when $default != null:
return $default(_that.halaqohName,_that.guruNama,_that.programType,_that.range,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String halaqohName,  String guruNama,  String programType,  ReportRange range,  DateTime startDate,  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _LaporanAbsensiHalaqohConfig():
return $default(_that.halaqohName,_that.guruNama,_that.programType,_that.range,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String halaqohName,  String guruNama,  String programType,  ReportRange range,  DateTime startDate,  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _LaporanAbsensiHalaqohConfig() when $default != null:
return $default(_that.halaqohName,_that.guruNama,_that.programType,_that.range,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _LaporanAbsensiHalaqohConfig implements LaporanAbsensiHalaqohConfig {
  const _LaporanAbsensiHalaqohConfig({required this.halaqohName, required this.guruNama, required this.programType, required this.range, required this.startDate, required this.endDate});
  

/// Name of the halaqoh (from HalaqohModel.nama)
@override final  String halaqohName;
/// Teacher's full name (from HalaqohModel.guruNama)
@override final  String guruNama;
/// 'reguler' | 'takhassus' — determines session columns & page orientation
@override final  String programType;
/// The teacher-selected range type
@override final  ReportRange range;
/// Inclusive report start date (midnight)
@override final  DateTime startDate;
/// Inclusive report end date (end of day)
@override final  DateTime endDate;

/// Create a copy of LaporanAbsensiHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaporanAbsensiHalaqohConfigCopyWith<_LaporanAbsensiHalaqohConfig> get copyWith => __$LaporanAbsensiHalaqohConfigCopyWithImpl<_LaporanAbsensiHalaqohConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaporanAbsensiHalaqohConfig&&(identical(other.halaqohName, halaqohName) || other.halaqohName == halaqohName)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.programType, programType) || other.programType == programType)&&(identical(other.range, range) || other.range == range)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,halaqohName,guruNama,programType,range,startDate,endDate);

@override
String toString() {
  return 'LaporanAbsensiHalaqohConfig(halaqohName: $halaqohName, guruNama: $guruNama, programType: $programType, range: $range, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$LaporanAbsensiHalaqohConfigCopyWith<$Res> implements $LaporanAbsensiHalaqohConfigCopyWith<$Res> {
  factory _$LaporanAbsensiHalaqohConfigCopyWith(_LaporanAbsensiHalaqohConfig value, $Res Function(_LaporanAbsensiHalaqohConfig) _then) = __$LaporanAbsensiHalaqohConfigCopyWithImpl;
@override @useResult
$Res call({
 String halaqohName, String guruNama, String programType, ReportRange range, DateTime startDate, DateTime endDate
});




}
/// @nodoc
class __$LaporanAbsensiHalaqohConfigCopyWithImpl<$Res>
    implements _$LaporanAbsensiHalaqohConfigCopyWith<$Res> {
  __$LaporanAbsensiHalaqohConfigCopyWithImpl(this._self, this._then);

  final _LaporanAbsensiHalaqohConfig _self;
  final $Res Function(_LaporanAbsensiHalaqohConfig) _then;

/// Create a copy of LaporanAbsensiHalaqohConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? halaqohName = null,Object? guruNama = null,Object? programType = null,Object? range = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_LaporanAbsensiHalaqohConfig(
halaqohName: null == halaqohName ? _self.halaqohName : halaqohName // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,programType: null == programType ? _self.programType : programType // ignore: cast_nullable_to_non_nullable
as String,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as ReportRange,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
