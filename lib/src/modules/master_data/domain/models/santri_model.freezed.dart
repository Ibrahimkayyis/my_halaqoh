// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'santri_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SantriModel {

/// Firestore document ID
 String get id;/// NIS — 12 digit unique identifier, also the barcode value on student card
 String get nis;/// Full name
 String get nama;/// Profile picture URL (Optional)
 String? get profilePicture;/// Class level: "7", "8", "9", "10", "11", "12"
 String get kelas;/// Program type: "R" (Reguler) or "T" (Takhassus)
 String get program;/// Reference to halaqoh document ID (nullable — assigned when halaqoh is created)
 String? get halaqohId;/// Nested wali santri (parent/guardian) information
 WaliSantriModel? get waliSantri;/// Firebase Auth UID (nullable — set after auth account is created)
 String? get authUid;/// Apakah santri ini sudah lulus (kelas 12 yang diarsipkan saat kenaikan kelas)?
/// Alumni disembunyikan dari daftar aktif tapi data tetap tersimpan di Firestore.
 bool get isAlumni; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SantriModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SantriModelCopyWith<SantriModel> get copyWith => _$SantriModelCopyWithImpl<SantriModel>(this as SantriModel, _$identity);

  /// Serializes this SantriModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SantriModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nis, nis) || other.nis == nis)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.waliSantri, waliSantri) || other.waliSantri == waliSantri)&&(identical(other.authUid, authUid) || other.authUid == authUid)&&(identical(other.isAlumni, isAlumni) || other.isAlumni == isAlumni)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nis,nama,profilePicture,kelas,program,halaqohId,waliSantri,authUid,isAlumni,createdAt,updatedAt);

@override
String toString() {
  return 'SantriModel(id: $id, nis: $nis, nama: $nama, profilePicture: $profilePicture, kelas: $kelas, program: $program, halaqohId: $halaqohId, waliSantri: $waliSantri, authUid: $authUid, isAlumni: $isAlumni, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SantriModelCopyWith<$Res>  {
  factory $SantriModelCopyWith(SantriModel value, $Res Function(SantriModel) _then) = _$SantriModelCopyWithImpl;
@useResult
$Res call({
 String id, String nis, String nama, String? profilePicture, String kelas, String program, String? halaqohId, WaliSantriModel? waliSantri, String? authUid, bool isAlumni, DateTime createdAt, DateTime updatedAt
});


$WaliSantriModelCopyWith<$Res>? get waliSantri;

}
/// @nodoc
class _$SantriModelCopyWithImpl<$Res>
    implements $SantriModelCopyWith<$Res> {
  _$SantriModelCopyWithImpl(this._self, this._then);

  final SantriModel _self;
  final $Res Function(SantriModel) _then;

/// Create a copy of SantriModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nis = null,Object? nama = null,Object? profilePicture = freezed,Object? kelas = null,Object? program = null,Object? halaqohId = freezed,Object? waliSantri = freezed,Object? authUid = freezed,Object? isAlumni = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nis: null == nis ? _self.nis : nis // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,halaqohId: freezed == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String?,waliSantri: freezed == waliSantri ? _self.waliSantri : waliSantri // ignore: cast_nullable_to_non_nullable
as WaliSantriModel?,authUid: freezed == authUid ? _self.authUid : authUid // ignore: cast_nullable_to_non_nullable
as String?,isAlumni: null == isAlumni ? _self.isAlumni : isAlumni // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SantriModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaliSantriModelCopyWith<$Res>? get waliSantri {
    if (_self.waliSantri == null) {
    return null;
  }

  return $WaliSantriModelCopyWith<$Res>(_self.waliSantri!, (value) {
    return _then(_self.copyWith(waliSantri: value));
  });
}
}


/// Adds pattern-matching-related methods to [SantriModel].
extension SantriModelPatterns on SantriModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SantriModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SantriModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SantriModel value)  $default,){
final _that = this;
switch (_that) {
case _SantriModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SantriModel value)?  $default,){
final _that = this;
switch (_that) {
case _SantriModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nis,  String nama,  String? profilePicture,  String kelas,  String program,  String? halaqohId,  WaliSantriModel? waliSantri,  String? authUid,  bool isAlumni,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SantriModel() when $default != null:
return $default(_that.id,_that.nis,_that.nama,_that.profilePicture,_that.kelas,_that.program,_that.halaqohId,_that.waliSantri,_that.authUid,_that.isAlumni,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nis,  String nama,  String? profilePicture,  String kelas,  String program,  String? halaqohId,  WaliSantriModel? waliSantri,  String? authUid,  bool isAlumni,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SantriModel():
return $default(_that.id,_that.nis,_that.nama,_that.profilePicture,_that.kelas,_that.program,_that.halaqohId,_that.waliSantri,_that.authUid,_that.isAlumni,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nis,  String nama,  String? profilePicture,  String kelas,  String program,  String? halaqohId,  WaliSantriModel? waliSantri,  String? authUid,  bool isAlumni,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SantriModel() when $default != null:
return $default(_that.id,_that.nis,_that.nama,_that.profilePicture,_that.kelas,_that.program,_that.halaqohId,_that.waliSantri,_that.authUid,_that.isAlumni,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SantriModel implements SantriModel {
  const _SantriModel({required this.id, required this.nis, required this.nama, this.profilePicture, required this.kelas, required this.program, this.halaqohId, this.waliSantri, this.authUid, this.isAlumni = false, required this.createdAt, required this.updatedAt});
  factory _SantriModel.fromJson(Map<String, dynamic> json) => _$SantriModelFromJson(json);

/// Firestore document ID
@override final  String id;
/// NIS — 12 digit unique identifier, also the barcode value on student card
@override final  String nis;
/// Full name
@override final  String nama;
/// Profile picture URL (Optional)
@override final  String? profilePicture;
/// Class level: "7", "8", "9", "10", "11", "12"
@override final  String kelas;
/// Program type: "R" (Reguler) or "T" (Takhassus)
@override final  String program;
/// Reference to halaqoh document ID (nullable — assigned when halaqoh is created)
@override final  String? halaqohId;
/// Nested wali santri (parent/guardian) information
@override final  WaliSantriModel? waliSantri;
/// Firebase Auth UID (nullable — set after auth account is created)
@override final  String? authUid;
/// Apakah santri ini sudah lulus (kelas 12 yang diarsipkan saat kenaikan kelas)?
/// Alumni disembunyikan dari daftar aktif tapi data tetap tersimpan di Firestore.
@override@JsonKey() final  bool isAlumni;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SantriModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SantriModelCopyWith<_SantriModel> get copyWith => __$SantriModelCopyWithImpl<_SantriModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SantriModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SantriModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nis, nis) || other.nis == nis)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.waliSantri, waliSantri) || other.waliSantri == waliSantri)&&(identical(other.authUid, authUid) || other.authUid == authUid)&&(identical(other.isAlumni, isAlumni) || other.isAlumni == isAlumni)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nis,nama,profilePicture,kelas,program,halaqohId,waliSantri,authUid,isAlumni,createdAt,updatedAt);

@override
String toString() {
  return 'SantriModel(id: $id, nis: $nis, nama: $nama, profilePicture: $profilePicture, kelas: $kelas, program: $program, halaqohId: $halaqohId, waliSantri: $waliSantri, authUid: $authUid, isAlumni: $isAlumni, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SantriModelCopyWith<$Res> implements $SantriModelCopyWith<$Res> {
  factory _$SantriModelCopyWith(_SantriModel value, $Res Function(_SantriModel) _then) = __$SantriModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String nis, String nama, String? profilePicture, String kelas, String program, String? halaqohId, WaliSantriModel? waliSantri, String? authUid, bool isAlumni, DateTime createdAt, DateTime updatedAt
});


@override $WaliSantriModelCopyWith<$Res>? get waliSantri;

}
/// @nodoc
class __$SantriModelCopyWithImpl<$Res>
    implements _$SantriModelCopyWith<$Res> {
  __$SantriModelCopyWithImpl(this._self, this._then);

  final _SantriModel _self;
  final $Res Function(_SantriModel) _then;

/// Create a copy of SantriModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nis = null,Object? nama = null,Object? profilePicture = freezed,Object? kelas = null,Object? program = null,Object? halaqohId = freezed,Object? waliSantri = freezed,Object? authUid = freezed,Object? isAlumni = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SantriModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nis: null == nis ? _self.nis : nis // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,halaqohId: freezed == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String?,waliSantri: freezed == waliSantri ? _self.waliSantri : waliSantri // ignore: cast_nullable_to_non_nullable
as WaliSantriModel?,authUid: freezed == authUid ? _self.authUid : authUid // ignore: cast_nullable_to_non_nullable
as String?,isAlumni: null == isAlumni ? _self.isAlumni : isAlumni // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SantriModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WaliSantriModelCopyWith<$Res>? get waliSantri {
    if (_self.waliSantri == null) {
    return null;
  }

  return $WaliSantriModelCopyWith<$Res>(_self.waliSantri!, (value) {
    return _then(_self.copyWith(waliSantri: value));
  });
}
}

// dart format on
