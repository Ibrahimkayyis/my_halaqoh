// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sertifikasi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SertifikasiModel {

/// Document ID in Firestore
 String get id;/// Target Santri Info
 String get santriId; String get santriNama; String get nis; String get kelas; String get program; String? get profilePicture;/// Halaqoh & Teacher Info
 String get halaqohId; String get halaqohNama; String get guruId; String get guruNama;/// Tested Juz (1..30)
 int get juz;/// Teacher's preparation note
 String? get catatanGuru;/// Status: 'pending' | 'scheduled' | 'rejected' | 'passed' | 'failed'
 String get status;/// Scheduling info (filled by Waka Tahfidz)
 DateTime? get tanggalUjian; String? get sesiUjian; String? get pengujiId; String? get pengujiNama; String? get catatanAdmin; String? get alasanPenolakan;/// Exam Score & Evaluation (filled after exam)
 int? get nilai; String? get predikat; String? get catatanPenguji;/// Timestamps
 DateTime get createdAt; DateTime get updatedAt; DateTime? get completedAt;
/// Create a copy of SertifikasiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SertifikasiModelCopyWith<SertifikasiModel> get copyWith => _$SertifikasiModelCopyWithImpl<SertifikasiModel>(this as SertifikasiModel, _$identity);

  /// Serializes this SertifikasiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SertifikasiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.santriNama, santriNama) || other.santriNama == santriNama)&&(identical(other.nis, nis) || other.nis == nis)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.halaqohNama, halaqohNama) || other.halaqohNama == halaqohNama)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.juz, juz) || other.juz == juz)&&(identical(other.catatanGuru, catatanGuru) || other.catatanGuru == catatanGuru)&&(identical(other.status, status) || other.status == status)&&(identical(other.tanggalUjian, tanggalUjian) || other.tanggalUjian == tanggalUjian)&&(identical(other.sesiUjian, sesiUjian) || other.sesiUjian == sesiUjian)&&(identical(other.pengujiId, pengujiId) || other.pengujiId == pengujiId)&&(identical(other.pengujiNama, pengujiNama) || other.pengujiNama == pengujiNama)&&(identical(other.catatanAdmin, catatanAdmin) || other.catatanAdmin == catatanAdmin)&&(identical(other.alasanPenolakan, alasanPenolakan) || other.alasanPenolakan == alasanPenolakan)&&(identical(other.nilai, nilai) || other.nilai == nilai)&&(identical(other.predikat, predikat) || other.predikat == predikat)&&(identical(other.catatanPenguji, catatanPenguji) || other.catatanPenguji == catatanPenguji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,santriId,santriNama,nis,kelas,program,profilePicture,halaqohId,halaqohNama,guruId,guruNama,juz,catatanGuru,status,tanggalUjian,sesiUjian,pengujiId,pengujiNama,catatanAdmin,alasanPenolakan,nilai,predikat,catatanPenguji,createdAt,updatedAt,completedAt]);

@override
String toString() {
  return 'SertifikasiModel(id: $id, santriId: $santriId, santriNama: $santriNama, nis: $nis, kelas: $kelas, program: $program, profilePicture: $profilePicture, halaqohId: $halaqohId, halaqohNama: $halaqohNama, guruId: $guruId, guruNama: $guruNama, juz: $juz, catatanGuru: $catatanGuru, status: $status, tanggalUjian: $tanggalUjian, sesiUjian: $sesiUjian, pengujiId: $pengujiId, pengujiNama: $pengujiNama, catatanAdmin: $catatanAdmin, alasanPenolakan: $alasanPenolakan, nilai: $nilai, predikat: $predikat, catatanPenguji: $catatanPenguji, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $SertifikasiModelCopyWith<$Res>  {
  factory $SertifikasiModelCopyWith(SertifikasiModel value, $Res Function(SertifikasiModel) _then) = _$SertifikasiModelCopyWithImpl;
@useResult
$Res call({
 String id, String santriId, String santriNama, String nis, String kelas, String program, String? profilePicture, String halaqohId, String halaqohNama, String guruId, String guruNama, int juz, String? catatanGuru, String status, DateTime? tanggalUjian, String? sesiUjian, String? pengujiId, String? pengujiNama, String? catatanAdmin, String? alasanPenolakan, int? nilai, String? predikat, String? catatanPenguji, DateTime createdAt, DateTime updatedAt, DateTime? completedAt
});




}
/// @nodoc
class _$SertifikasiModelCopyWithImpl<$Res>
    implements $SertifikasiModelCopyWith<$Res> {
  _$SertifikasiModelCopyWithImpl(this._self, this._then);

  final SertifikasiModel _self;
  final $Res Function(SertifikasiModel) _then;

/// Create a copy of SertifikasiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? santriId = null,Object? santriNama = null,Object? nis = null,Object? kelas = null,Object? program = null,Object? profilePicture = freezed,Object? halaqohId = null,Object? halaqohNama = null,Object? guruId = null,Object? guruNama = null,Object? juz = null,Object? catatanGuru = freezed,Object? status = null,Object? tanggalUjian = freezed,Object? sesiUjian = freezed,Object? pengujiId = freezed,Object? pengujiNama = freezed,Object? catatanAdmin = freezed,Object? alasanPenolakan = freezed,Object? nilai = freezed,Object? predikat = freezed,Object? catatanPenguji = freezed,Object? createdAt = null,Object? updatedAt = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,santriNama: null == santriNama ? _self.santriNama : santriNama // ignore: cast_nullable_to_non_nullable
as String,nis: null == nis ? _self.nis : nis // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,halaqohId: null == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String,halaqohNama: null == halaqohNama ? _self.halaqohNama : halaqohNama // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,juz: null == juz ? _self.juz : juz // ignore: cast_nullable_to_non_nullable
as int,catatanGuru: freezed == catatanGuru ? _self.catatanGuru : catatanGuru // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tanggalUjian: freezed == tanggalUjian ? _self.tanggalUjian : tanggalUjian // ignore: cast_nullable_to_non_nullable
as DateTime?,sesiUjian: freezed == sesiUjian ? _self.sesiUjian : sesiUjian // ignore: cast_nullable_to_non_nullable
as String?,pengujiId: freezed == pengujiId ? _self.pengujiId : pengujiId // ignore: cast_nullable_to_non_nullable
as String?,pengujiNama: freezed == pengujiNama ? _self.pengujiNama : pengujiNama // ignore: cast_nullable_to_non_nullable
as String?,catatanAdmin: freezed == catatanAdmin ? _self.catatanAdmin : catatanAdmin // ignore: cast_nullable_to_non_nullable
as String?,alasanPenolakan: freezed == alasanPenolakan ? _self.alasanPenolakan : alasanPenolakan // ignore: cast_nullable_to_non_nullable
as String?,nilai: freezed == nilai ? _self.nilai : nilai // ignore: cast_nullable_to_non_nullable
as int?,predikat: freezed == predikat ? _self.predikat : predikat // ignore: cast_nullable_to_non_nullable
as String?,catatanPenguji: freezed == catatanPenguji ? _self.catatanPenguji : catatanPenguji // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SertifikasiModel].
extension SertifikasiModelPatterns on SertifikasiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SertifikasiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SertifikasiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SertifikasiModel value)  $default,){
final _that = this;
switch (_that) {
case _SertifikasiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SertifikasiModel value)?  $default,){
final _that = this;
switch (_that) {
case _SertifikasiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String santriId,  String santriNama,  String nis,  String kelas,  String program,  String? profilePicture,  String halaqohId,  String halaqohNama,  String guruId,  String guruNama,  int juz,  String? catatanGuru,  String status,  DateTime? tanggalUjian,  String? sesiUjian,  String? pengujiId,  String? pengujiNama,  String? catatanAdmin,  String? alasanPenolakan,  int? nilai,  String? predikat,  String? catatanPenguji,  DateTime createdAt,  DateTime updatedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SertifikasiModel() when $default != null:
return $default(_that.id,_that.santriId,_that.santriNama,_that.nis,_that.kelas,_that.program,_that.profilePicture,_that.halaqohId,_that.halaqohNama,_that.guruId,_that.guruNama,_that.juz,_that.catatanGuru,_that.status,_that.tanggalUjian,_that.sesiUjian,_that.pengujiId,_that.pengujiNama,_that.catatanAdmin,_that.alasanPenolakan,_that.nilai,_that.predikat,_that.catatanPenguji,_that.createdAt,_that.updatedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String santriId,  String santriNama,  String nis,  String kelas,  String program,  String? profilePicture,  String halaqohId,  String halaqohNama,  String guruId,  String guruNama,  int juz,  String? catatanGuru,  String status,  DateTime? tanggalUjian,  String? sesiUjian,  String? pengujiId,  String? pengujiNama,  String? catatanAdmin,  String? alasanPenolakan,  int? nilai,  String? predikat,  String? catatanPenguji,  DateTime createdAt,  DateTime updatedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _SertifikasiModel():
return $default(_that.id,_that.santriId,_that.santriNama,_that.nis,_that.kelas,_that.program,_that.profilePicture,_that.halaqohId,_that.halaqohNama,_that.guruId,_that.guruNama,_that.juz,_that.catatanGuru,_that.status,_that.tanggalUjian,_that.sesiUjian,_that.pengujiId,_that.pengujiNama,_that.catatanAdmin,_that.alasanPenolakan,_that.nilai,_that.predikat,_that.catatanPenguji,_that.createdAt,_that.updatedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String santriId,  String santriNama,  String nis,  String kelas,  String program,  String? profilePicture,  String halaqohId,  String halaqohNama,  String guruId,  String guruNama,  int juz,  String? catatanGuru,  String status,  DateTime? tanggalUjian,  String? sesiUjian,  String? pengujiId,  String? pengujiNama,  String? catatanAdmin,  String? alasanPenolakan,  int? nilai,  String? predikat,  String? catatanPenguji,  DateTime createdAt,  DateTime updatedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _SertifikasiModel() when $default != null:
return $default(_that.id,_that.santriId,_that.santriNama,_that.nis,_that.kelas,_that.program,_that.profilePicture,_that.halaqohId,_that.halaqohNama,_that.guruId,_that.guruNama,_that.juz,_that.catatanGuru,_that.status,_that.tanggalUjian,_that.sesiUjian,_that.pengujiId,_that.pengujiNama,_that.catatanAdmin,_that.alasanPenolakan,_that.nilai,_that.predikat,_that.catatanPenguji,_that.createdAt,_that.updatedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SertifikasiModel implements SertifikasiModel {
  const _SertifikasiModel({required this.id, required this.santriId, required this.santriNama, required this.nis, required this.kelas, required this.program, this.profilePicture, required this.halaqohId, required this.halaqohNama, required this.guruId, required this.guruNama, required this.juz, this.catatanGuru, this.status = 'pending', this.tanggalUjian, this.sesiUjian, this.pengujiId, this.pengujiNama, this.catatanAdmin, this.alasanPenolakan, this.nilai, this.predikat, this.catatanPenguji, required this.createdAt, required this.updatedAt, this.completedAt});
  factory _SertifikasiModel.fromJson(Map<String, dynamic> json) => _$SertifikasiModelFromJson(json);

/// Document ID in Firestore
@override final  String id;
/// Target Santri Info
@override final  String santriId;
@override final  String santriNama;
@override final  String nis;
@override final  String kelas;
@override final  String program;
@override final  String? profilePicture;
/// Halaqoh & Teacher Info
@override final  String halaqohId;
@override final  String halaqohNama;
@override final  String guruId;
@override final  String guruNama;
/// Tested Juz (1..30)
@override final  int juz;
/// Teacher's preparation note
@override final  String? catatanGuru;
/// Status: 'pending' | 'scheduled' | 'rejected' | 'passed' | 'failed'
@override@JsonKey() final  String status;
/// Scheduling info (filled by Waka Tahfidz)
@override final  DateTime? tanggalUjian;
@override final  String? sesiUjian;
@override final  String? pengujiId;
@override final  String? pengujiNama;
@override final  String? catatanAdmin;
@override final  String? alasanPenolakan;
/// Exam Score & Evaluation (filled after exam)
@override final  int? nilai;
@override final  String? predikat;
@override final  String? catatanPenguji;
/// Timestamps
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? completedAt;

/// Create a copy of SertifikasiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SertifikasiModelCopyWith<_SertifikasiModel> get copyWith => __$SertifikasiModelCopyWithImpl<_SertifikasiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SertifikasiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SertifikasiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.santriNama, santriNama) || other.santriNama == santriNama)&&(identical(other.nis, nis) || other.nis == nis)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.halaqohNama, halaqohNama) || other.halaqohNama == halaqohNama)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&(identical(other.juz, juz) || other.juz == juz)&&(identical(other.catatanGuru, catatanGuru) || other.catatanGuru == catatanGuru)&&(identical(other.status, status) || other.status == status)&&(identical(other.tanggalUjian, tanggalUjian) || other.tanggalUjian == tanggalUjian)&&(identical(other.sesiUjian, sesiUjian) || other.sesiUjian == sesiUjian)&&(identical(other.pengujiId, pengujiId) || other.pengujiId == pengujiId)&&(identical(other.pengujiNama, pengujiNama) || other.pengujiNama == pengujiNama)&&(identical(other.catatanAdmin, catatanAdmin) || other.catatanAdmin == catatanAdmin)&&(identical(other.alasanPenolakan, alasanPenolakan) || other.alasanPenolakan == alasanPenolakan)&&(identical(other.nilai, nilai) || other.nilai == nilai)&&(identical(other.predikat, predikat) || other.predikat == predikat)&&(identical(other.catatanPenguji, catatanPenguji) || other.catatanPenguji == catatanPenguji)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,santriId,santriNama,nis,kelas,program,profilePicture,halaqohId,halaqohNama,guruId,guruNama,juz,catatanGuru,status,tanggalUjian,sesiUjian,pengujiId,pengujiNama,catatanAdmin,alasanPenolakan,nilai,predikat,catatanPenguji,createdAt,updatedAt,completedAt]);

@override
String toString() {
  return 'SertifikasiModel(id: $id, santriId: $santriId, santriNama: $santriNama, nis: $nis, kelas: $kelas, program: $program, profilePicture: $profilePicture, halaqohId: $halaqohId, halaqohNama: $halaqohNama, guruId: $guruId, guruNama: $guruNama, juz: $juz, catatanGuru: $catatanGuru, status: $status, tanggalUjian: $tanggalUjian, sesiUjian: $sesiUjian, pengujiId: $pengujiId, pengujiNama: $pengujiNama, catatanAdmin: $catatanAdmin, alasanPenolakan: $alasanPenolakan, nilai: $nilai, predikat: $predikat, catatanPenguji: $catatanPenguji, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$SertifikasiModelCopyWith<$Res> implements $SertifikasiModelCopyWith<$Res> {
  factory _$SertifikasiModelCopyWith(_SertifikasiModel value, $Res Function(_SertifikasiModel) _then) = __$SertifikasiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String santriId, String santriNama, String nis, String kelas, String program, String? profilePicture, String halaqohId, String halaqohNama, String guruId, String guruNama, int juz, String? catatanGuru, String status, DateTime? tanggalUjian, String? sesiUjian, String? pengujiId, String? pengujiNama, String? catatanAdmin, String? alasanPenolakan, int? nilai, String? predikat, String? catatanPenguji, DateTime createdAt, DateTime updatedAt, DateTime? completedAt
});




}
/// @nodoc
class __$SertifikasiModelCopyWithImpl<$Res>
    implements _$SertifikasiModelCopyWith<$Res> {
  __$SertifikasiModelCopyWithImpl(this._self, this._then);

  final _SertifikasiModel _self;
  final $Res Function(_SertifikasiModel) _then;

/// Create a copy of SertifikasiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? santriId = null,Object? santriNama = null,Object? nis = null,Object? kelas = null,Object? program = null,Object? profilePicture = freezed,Object? halaqohId = null,Object? halaqohNama = null,Object? guruId = null,Object? guruNama = null,Object? juz = null,Object? catatanGuru = freezed,Object? status = null,Object? tanggalUjian = freezed,Object? sesiUjian = freezed,Object? pengujiId = freezed,Object? pengujiNama = freezed,Object? catatanAdmin = freezed,Object? alasanPenolakan = freezed,Object? nilai = freezed,Object? predikat = freezed,Object? catatanPenguji = freezed,Object? createdAt = null,Object? updatedAt = null,Object? completedAt = freezed,}) {
  return _then(_SertifikasiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,santriNama: null == santriNama ? _self.santriNama : santriNama // ignore: cast_nullable_to_non_nullable
as String,nis: null == nis ? _self.nis : nis // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,halaqohId: null == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String,halaqohNama: null == halaqohNama ? _self.halaqohNama : halaqohNama // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,juz: null == juz ? _self.juz : juz // ignore: cast_nullable_to_non_nullable
as int,catatanGuru: freezed == catatanGuru ? _self.catatanGuru : catatanGuru // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tanggalUjian: freezed == tanggalUjian ? _self.tanggalUjian : tanggalUjian // ignore: cast_nullable_to_non_nullable
as DateTime?,sesiUjian: freezed == sesiUjian ? _self.sesiUjian : sesiUjian // ignore: cast_nullable_to_non_nullable
as String?,pengujiId: freezed == pengujiId ? _self.pengujiId : pengujiId // ignore: cast_nullable_to_non_nullable
as String?,pengujiNama: freezed == pengujiNama ? _self.pengujiNama : pengujiNama // ignore: cast_nullable_to_non_nullable
as String?,catatanAdmin: freezed == catatanAdmin ? _self.catatanAdmin : catatanAdmin // ignore: cast_nullable_to_non_nullable
as String?,alasanPenolakan: freezed == alasanPenolakan ? _self.alasanPenolakan : alasanPenolakan // ignore: cast_nullable_to_non_nullable
as String?,nilai: freezed == nilai ? _self.nilai : nilai // ignore: cast_nullable_to_non_nullable
as int?,predikat: freezed == predikat ? _self.predikat : predikat // ignore: cast_nullable_to_non_nullable
as String?,catatanPenguji: freezed == catatanPenguji ? _self.catatanPenguji : catatanPenguji // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
