// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'target_hafalan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TargetHafalanModel {

/// Document ID: "{kelas}_{program}", e.g. "7_Reguler"
 String get id;/// Class level: "7", "8", ..., "12"
 String get kelas;/// Program: "Reguler" or "Takhassus"
 String get program;/// Academic year, e.g. "2025 / 2026"
 String get tahunAjaran;/// Active semester set by admin: 1 or 2. Null = not yet set.
 int? get semesterAktif; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TargetHafalanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetHafalanModelCopyWith<TargetHafalanModel> get copyWith => _$TargetHafalanModelCopyWithImpl<TargetHafalanModel>(this as TargetHafalanModel, _$identity);

  /// Serializes this TargetHafalanModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TargetHafalanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.tahunAjaran, tahunAjaran) || other.tahunAjaran == tahunAjaran)&&(identical(other.semesterAktif, semesterAktif) || other.semesterAktif == semesterAktif)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kelas,program,tahunAjaran,semesterAktif,createdAt,updatedAt);

@override
String toString() {
  return 'TargetHafalanModel(id: $id, kelas: $kelas, program: $program, tahunAjaran: $tahunAjaran, semesterAktif: $semesterAktif, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TargetHafalanModelCopyWith<$Res>  {
  factory $TargetHafalanModelCopyWith(TargetHafalanModel value, $Res Function(TargetHafalanModel) _then) = _$TargetHafalanModelCopyWithImpl;
@useResult
$Res call({
 String id, String kelas, String program, String tahunAjaran, int? semesterAktif, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TargetHafalanModelCopyWithImpl<$Res>
    implements $TargetHafalanModelCopyWith<$Res> {
  _$TargetHafalanModelCopyWithImpl(this._self, this._then);

  final TargetHafalanModel _self;
  final $Res Function(TargetHafalanModel) _then;

/// Create a copy of TargetHafalanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kelas = null,Object? program = null,Object? tahunAjaran = null,Object? semesterAktif = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,tahunAjaran: null == tahunAjaran ? _self.tahunAjaran : tahunAjaran // ignore: cast_nullable_to_non_nullable
as String,semesterAktif: freezed == semesterAktif ? _self.semesterAktif : semesterAktif // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TargetHafalanModel].
extension TargetHafalanModelPatterns on TargetHafalanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TargetHafalanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TargetHafalanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TargetHafalanModel value)  $default,){
final _that = this;
switch (_that) {
case _TargetHafalanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TargetHafalanModel value)?  $default,){
final _that = this;
switch (_that) {
case _TargetHafalanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kelas,  String program,  String tahunAjaran,  int? semesterAktif,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TargetHafalanModel() when $default != null:
return $default(_that.id,_that.kelas,_that.program,_that.tahunAjaran,_that.semesterAktif,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kelas,  String program,  String tahunAjaran,  int? semesterAktif,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TargetHafalanModel():
return $default(_that.id,_that.kelas,_that.program,_that.tahunAjaran,_that.semesterAktif,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kelas,  String program,  String tahunAjaran,  int? semesterAktif,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TargetHafalanModel() when $default != null:
return $default(_that.id,_that.kelas,_that.program,_that.tahunAjaran,_that.semesterAktif,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TargetHafalanModel implements TargetHafalanModel {
  const _TargetHafalanModel({required this.id, required this.kelas, required this.program, this.tahunAjaran = '', this.semesterAktif = null, required this.createdAt, required this.updatedAt});
  factory _TargetHafalanModel.fromJson(Map<String, dynamic> json) => _$TargetHafalanModelFromJson(json);

/// Document ID: "{kelas}_{program}", e.g. "7_Reguler"
@override final  String id;
/// Class level: "7", "8", ..., "12"
@override final  String kelas;
/// Program: "Reguler" or "Takhassus"
@override final  String program;
/// Academic year, e.g. "2025 / 2026"
@override@JsonKey() final  String tahunAjaran;
/// Active semester set by admin: 1 or 2. Null = not yet set.
@override@JsonKey() final  int? semesterAktif;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TargetHafalanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetHafalanModelCopyWith<_TargetHafalanModel> get copyWith => __$TargetHafalanModelCopyWithImpl<_TargetHafalanModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TargetHafalanModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TargetHafalanModel&&(identical(other.id, id) || other.id == id)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.tahunAjaran, tahunAjaran) || other.tahunAjaran == tahunAjaran)&&(identical(other.semesterAktif, semesterAktif) || other.semesterAktif == semesterAktif)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kelas,program,tahunAjaran,semesterAktif,createdAt,updatedAt);

@override
String toString() {
  return 'TargetHafalanModel(id: $id, kelas: $kelas, program: $program, tahunAjaran: $tahunAjaran, semesterAktif: $semesterAktif, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TargetHafalanModelCopyWith<$Res> implements $TargetHafalanModelCopyWith<$Res> {
  factory _$TargetHafalanModelCopyWith(_TargetHafalanModel value, $Res Function(_TargetHafalanModel) _then) = __$TargetHafalanModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String kelas, String program, String tahunAjaran, int? semesterAktif, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TargetHafalanModelCopyWithImpl<$Res>
    implements _$TargetHafalanModelCopyWith<$Res> {
  __$TargetHafalanModelCopyWithImpl(this._self, this._then);

  final _TargetHafalanModel _self;
  final $Res Function(_TargetHafalanModel) _then;

/// Create a copy of TargetHafalanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kelas = null,Object? program = null,Object? tahunAjaran = null,Object? semesterAktif = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TargetHafalanModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,tahunAjaran: null == tahunAjaran ? _self.tahunAjaran : tahunAjaran // ignore: cast_nullable_to_non_nullable
as String,semesterAktif: freezed == semesterAktif ? _self.semesterAktif : semesterAktif // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
