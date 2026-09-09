// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absensi_record_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbsensiRecordEntry {

/// Firestore document ID of the santri
 String get santriId;/// NIS — unique student identifier
 String get nis;/// Student full name (denormalized for offline display)
 String get nama;/// Attendance status: 'hadir', 'sakit', 'izin', 'alfa'
 String get status;
/// Create a copy of AbsensiRecordEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsensiRecordEntryCopyWith<AbsensiRecordEntry> get copyWith => _$AbsensiRecordEntryCopyWithImpl<AbsensiRecordEntry>(this as AbsensiRecordEntry, _$identity);

  /// Serializes this AbsensiRecordEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsensiRecordEntry&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.nis, nis) || other.nis == nis)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,santriId,nis,nama,status);

@override
String toString() {
  return 'AbsensiRecordEntry(santriId: $santriId, nis: $nis, nama: $nama, status: $status)';
}


}

/// @nodoc
abstract mixin class $AbsensiRecordEntryCopyWith<$Res>  {
  factory $AbsensiRecordEntryCopyWith(AbsensiRecordEntry value, $Res Function(AbsensiRecordEntry) _then) = _$AbsensiRecordEntryCopyWithImpl;
@useResult
$Res call({
 String santriId, String nis, String nama, String status
});




}
/// @nodoc
class _$AbsensiRecordEntryCopyWithImpl<$Res>
    implements $AbsensiRecordEntryCopyWith<$Res> {
  _$AbsensiRecordEntryCopyWithImpl(this._self, this._then);

  final AbsensiRecordEntry _self;
  final $Res Function(AbsensiRecordEntry) _then;

/// Create a copy of AbsensiRecordEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? santriId = null,Object? nis = null,Object? nama = null,Object? status = null,}) {
  return _then(_self.copyWith(
santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,nis: null == nis ? _self.nis : nis // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AbsensiRecordEntry].
extension AbsensiRecordEntryPatterns on AbsensiRecordEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsensiRecordEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsensiRecordEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsensiRecordEntry value)  $default,){
final _that = this;
switch (_that) {
case _AbsensiRecordEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsensiRecordEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AbsensiRecordEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String santriId,  String nis,  String nama,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsensiRecordEntry() when $default != null:
return $default(_that.santriId,_that.nis,_that.nama,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String santriId,  String nis,  String nama,  String status)  $default,) {final _that = this;
switch (_that) {
case _AbsensiRecordEntry():
return $default(_that.santriId,_that.nis,_that.nama,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String santriId,  String nis,  String nama,  String status)?  $default,) {final _that = this;
switch (_that) {
case _AbsensiRecordEntry() when $default != null:
return $default(_that.santriId,_that.nis,_that.nama,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsensiRecordEntry implements AbsensiRecordEntry {
  const _AbsensiRecordEntry({required this.santriId, required this.nis, required this.nama, required this.status});
  factory _AbsensiRecordEntry.fromJson(Map<String, dynamic> json) => _$AbsensiRecordEntryFromJson(json);

/// Firestore document ID of the santri
@override final  String santriId;
/// NIS — unique student identifier
@override final  String nis;
/// Student full name (denormalized for offline display)
@override final  String nama;
/// Attendance status: 'hadir', 'sakit', 'izin', 'alfa'
@override final  String status;

/// Create a copy of AbsensiRecordEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsensiRecordEntryCopyWith<_AbsensiRecordEntry> get copyWith => __$AbsensiRecordEntryCopyWithImpl<_AbsensiRecordEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsensiRecordEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsensiRecordEntry&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.nis, nis) || other.nis == nis)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,santriId,nis,nama,status);

@override
String toString() {
  return 'AbsensiRecordEntry(santriId: $santriId, nis: $nis, nama: $nama, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AbsensiRecordEntryCopyWith<$Res> implements $AbsensiRecordEntryCopyWith<$Res> {
  factory _$AbsensiRecordEntryCopyWith(_AbsensiRecordEntry value, $Res Function(_AbsensiRecordEntry) _then) = __$AbsensiRecordEntryCopyWithImpl;
@override @useResult
$Res call({
 String santriId, String nis, String nama, String status
});




}
/// @nodoc
class __$AbsensiRecordEntryCopyWithImpl<$Res>
    implements _$AbsensiRecordEntryCopyWith<$Res> {
  __$AbsensiRecordEntryCopyWithImpl(this._self, this._then);

  final _AbsensiRecordEntry _self;
  final $Res Function(_AbsensiRecordEntry) _then;

/// Create a copy of AbsensiRecordEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? santriId = null,Object? nis = null,Object? nama = null,Object? status = null,}) {
  return _then(_AbsensiRecordEntry(
santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,nis: null == nis ? _self.nis : nis // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
