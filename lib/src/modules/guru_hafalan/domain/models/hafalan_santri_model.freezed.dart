// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hafalan_santri_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HafalanSantriModel {

 String get id; String get santriId; String get guruId; String get halaqohId; DateTime get tanggalSetoran; String get jenis;// "Ziyadah" or "Murajaah"
 int get surahId; String get surahName; int get ayatMulai; int get ayatSelesai; int get juz; int get nilaiKelancaran; int get nilaiTajwid; DateTime get createdAt; bool get isSynced;// Server-only field: written by sendHafalanNotification Cloud Function
// after FCM dispatch. NEVER set by the client.
@JsonKey(name: 'notifiedAt') DateTime? get notifiedAt;
/// Create a copy of HafalanSantriModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HafalanSantriModelCopyWith<HafalanSantriModel> get copyWith => _$HafalanSantriModelCopyWithImpl<HafalanSantriModel>(this as HafalanSantriModel, _$identity);

  /// Serializes this HafalanSantriModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HafalanSantriModel&&(identical(other.id, id) || other.id == id)&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.tanggalSetoran, tanggalSetoran) || other.tanggalSetoran == tanggalSetoran)&&(identical(other.jenis, jenis) || other.jenis == jenis)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.ayatMulai, ayatMulai) || other.ayatMulai == ayatMulai)&&(identical(other.ayatSelesai, ayatSelesai) || other.ayatSelesai == ayatSelesai)&&(identical(other.juz, juz) || other.juz == juz)&&(identical(other.nilaiKelancaran, nilaiKelancaran) || other.nilaiKelancaran == nilaiKelancaran)&&(identical(other.nilaiTajwid, nilaiTajwid) || other.nilaiTajwid == nilaiTajwid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced)&&(identical(other.notifiedAt, notifiedAt) || other.notifiedAt == notifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,santriId,guruId,halaqohId,tanggalSetoran,jenis,surahId,surahName,ayatMulai,ayatSelesai,juz,nilaiKelancaran,nilaiTajwid,createdAt,isSynced,notifiedAt);

@override
String toString() {
  return 'HafalanSantriModel(id: $id, santriId: $santriId, guruId: $guruId, halaqohId: $halaqohId, tanggalSetoran: $tanggalSetoran, jenis: $jenis, surahId: $surahId, surahName: $surahName, ayatMulai: $ayatMulai, ayatSelesai: $ayatSelesai, juz: $juz, nilaiKelancaran: $nilaiKelancaran, nilaiTajwid: $nilaiTajwid, createdAt: $createdAt, isSynced: $isSynced, notifiedAt: $notifiedAt)';
}


}

/// @nodoc
abstract mixin class $HafalanSantriModelCopyWith<$Res>  {
  factory $HafalanSantriModelCopyWith(HafalanSantriModel value, $Res Function(HafalanSantriModel) _then) = _$HafalanSantriModelCopyWithImpl;
@useResult
$Res call({
 String id, String santriId, String guruId, String halaqohId, DateTime tanggalSetoran, String jenis, int surahId, String surahName, int ayatMulai, int ayatSelesai, int juz, int nilaiKelancaran, int nilaiTajwid, DateTime createdAt, bool isSynced,@JsonKey(name: 'notifiedAt') DateTime? notifiedAt
});




}
/// @nodoc
class _$HafalanSantriModelCopyWithImpl<$Res>
    implements $HafalanSantriModelCopyWith<$Res> {
  _$HafalanSantriModelCopyWithImpl(this._self, this._then);

  final HafalanSantriModel _self;
  final $Res Function(HafalanSantriModel) _then;

/// Create a copy of HafalanSantriModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? santriId = null,Object? guruId = null,Object? halaqohId = null,Object? tanggalSetoran = null,Object? jenis = null,Object? surahId = null,Object? surahName = null,Object? ayatMulai = null,Object? ayatSelesai = null,Object? juz = null,Object? nilaiKelancaran = null,Object? nilaiTajwid = null,Object? createdAt = null,Object? isSynced = null,Object? notifiedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,halaqohId: null == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String,tanggalSetoran: null == tanggalSetoran ? _self.tanggalSetoran : tanggalSetoran // ignore: cast_nullable_to_non_nullable
as DateTime,jenis: null == jenis ? _self.jenis : jenis // ignore: cast_nullable_to_non_nullable
as String,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,surahName: null == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String,ayatMulai: null == ayatMulai ? _self.ayatMulai : ayatMulai // ignore: cast_nullable_to_non_nullable
as int,ayatSelesai: null == ayatSelesai ? _self.ayatSelesai : ayatSelesai // ignore: cast_nullable_to_non_nullable
as int,juz: null == juz ? _self.juz : juz // ignore: cast_nullable_to_non_nullable
as int,nilaiKelancaran: null == nilaiKelancaran ? _self.nilaiKelancaran : nilaiKelancaran // ignore: cast_nullable_to_non_nullable
as int,nilaiTajwid: null == nilaiTajwid ? _self.nilaiTajwid : nilaiTajwid // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,notifiedAt: freezed == notifiedAt ? _self.notifiedAt : notifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HafalanSantriModel].
extension HafalanSantriModelPatterns on HafalanSantriModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HafalanSantriModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HafalanSantriModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HafalanSantriModel value)  $default,){
final _that = this;
switch (_that) {
case _HafalanSantriModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HafalanSantriModel value)?  $default,){
final _that = this;
switch (_that) {
case _HafalanSantriModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String santriId,  String guruId,  String halaqohId,  DateTime tanggalSetoran,  String jenis,  int surahId,  String surahName,  int ayatMulai,  int ayatSelesai,  int juz,  int nilaiKelancaran,  int nilaiTajwid,  DateTime createdAt,  bool isSynced, @JsonKey(name: 'notifiedAt')  DateTime? notifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HafalanSantriModel() when $default != null:
return $default(_that.id,_that.santriId,_that.guruId,_that.halaqohId,_that.tanggalSetoran,_that.jenis,_that.surahId,_that.surahName,_that.ayatMulai,_that.ayatSelesai,_that.juz,_that.nilaiKelancaran,_that.nilaiTajwid,_that.createdAt,_that.isSynced,_that.notifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String santriId,  String guruId,  String halaqohId,  DateTime tanggalSetoran,  String jenis,  int surahId,  String surahName,  int ayatMulai,  int ayatSelesai,  int juz,  int nilaiKelancaran,  int nilaiTajwid,  DateTime createdAt,  bool isSynced, @JsonKey(name: 'notifiedAt')  DateTime? notifiedAt)  $default,) {final _that = this;
switch (_that) {
case _HafalanSantriModel():
return $default(_that.id,_that.santriId,_that.guruId,_that.halaqohId,_that.tanggalSetoran,_that.jenis,_that.surahId,_that.surahName,_that.ayatMulai,_that.ayatSelesai,_that.juz,_that.nilaiKelancaran,_that.nilaiTajwid,_that.createdAt,_that.isSynced,_that.notifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String santriId,  String guruId,  String halaqohId,  DateTime tanggalSetoran,  String jenis,  int surahId,  String surahName,  int ayatMulai,  int ayatSelesai,  int juz,  int nilaiKelancaran,  int nilaiTajwid,  DateTime createdAt,  bool isSynced, @JsonKey(name: 'notifiedAt')  DateTime? notifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _HafalanSantriModel() when $default != null:
return $default(_that.id,_that.santriId,_that.guruId,_that.halaqohId,_that.tanggalSetoran,_that.jenis,_that.surahId,_that.surahName,_that.ayatMulai,_that.ayatSelesai,_that.juz,_that.nilaiKelancaran,_that.nilaiTajwid,_that.createdAt,_that.isSynced,_that.notifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HafalanSantriModel implements HafalanSantriModel {
  const _HafalanSantriModel({required this.id, required this.santriId, required this.guruId, required this.halaqohId, required this.tanggalSetoran, required this.jenis, required this.surahId, required this.surahName, required this.ayatMulai, required this.ayatSelesai, required this.juz, required this.nilaiKelancaran, required this.nilaiTajwid, required this.createdAt, this.isSynced = false, @JsonKey(name: 'notifiedAt') this.notifiedAt});
  factory _HafalanSantriModel.fromJson(Map<String, dynamic> json) => _$HafalanSantriModelFromJson(json);

@override final  String id;
@override final  String santriId;
@override final  String guruId;
@override final  String halaqohId;
@override final  DateTime tanggalSetoran;
@override final  String jenis;
// "Ziyadah" or "Murajaah"
@override final  int surahId;
@override final  String surahName;
@override final  int ayatMulai;
@override final  int ayatSelesai;
@override final  int juz;
@override final  int nilaiKelancaran;
@override final  int nilaiTajwid;
@override final  DateTime createdAt;
@override@JsonKey() final  bool isSynced;
// Server-only field: written by sendHafalanNotification Cloud Function
// after FCM dispatch. NEVER set by the client.
@override@JsonKey(name: 'notifiedAt') final  DateTime? notifiedAt;

/// Create a copy of HafalanSantriModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HafalanSantriModelCopyWith<_HafalanSantriModel> get copyWith => __$HafalanSantriModelCopyWithImpl<_HafalanSantriModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HafalanSantriModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HafalanSantriModel&&(identical(other.id, id) || other.id == id)&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.tanggalSetoran, tanggalSetoran) || other.tanggalSetoran == tanggalSetoran)&&(identical(other.jenis, jenis) || other.jenis == jenis)&&(identical(other.surahId, surahId) || other.surahId == surahId)&&(identical(other.surahName, surahName) || other.surahName == surahName)&&(identical(other.ayatMulai, ayatMulai) || other.ayatMulai == ayatMulai)&&(identical(other.ayatSelesai, ayatSelesai) || other.ayatSelesai == ayatSelesai)&&(identical(other.juz, juz) || other.juz == juz)&&(identical(other.nilaiKelancaran, nilaiKelancaran) || other.nilaiKelancaran == nilaiKelancaran)&&(identical(other.nilaiTajwid, nilaiTajwid) || other.nilaiTajwid == nilaiTajwid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced)&&(identical(other.notifiedAt, notifiedAt) || other.notifiedAt == notifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,santriId,guruId,halaqohId,tanggalSetoran,jenis,surahId,surahName,ayatMulai,ayatSelesai,juz,nilaiKelancaran,nilaiTajwid,createdAt,isSynced,notifiedAt);

@override
String toString() {
  return 'HafalanSantriModel(id: $id, santriId: $santriId, guruId: $guruId, halaqohId: $halaqohId, tanggalSetoran: $tanggalSetoran, jenis: $jenis, surahId: $surahId, surahName: $surahName, ayatMulai: $ayatMulai, ayatSelesai: $ayatSelesai, juz: $juz, nilaiKelancaran: $nilaiKelancaran, nilaiTajwid: $nilaiTajwid, createdAt: $createdAt, isSynced: $isSynced, notifiedAt: $notifiedAt)';
}


}

/// @nodoc
abstract mixin class _$HafalanSantriModelCopyWith<$Res> implements $HafalanSantriModelCopyWith<$Res> {
  factory _$HafalanSantriModelCopyWith(_HafalanSantriModel value, $Res Function(_HafalanSantriModel) _then) = __$HafalanSantriModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String santriId, String guruId, String halaqohId, DateTime tanggalSetoran, String jenis, int surahId, String surahName, int ayatMulai, int ayatSelesai, int juz, int nilaiKelancaran, int nilaiTajwid, DateTime createdAt, bool isSynced,@JsonKey(name: 'notifiedAt') DateTime? notifiedAt
});




}
/// @nodoc
class __$HafalanSantriModelCopyWithImpl<$Res>
    implements _$HafalanSantriModelCopyWith<$Res> {
  __$HafalanSantriModelCopyWithImpl(this._self, this._then);

  final _HafalanSantriModel _self;
  final $Res Function(_HafalanSantriModel) _then;

/// Create a copy of HafalanSantriModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? santriId = null,Object? guruId = null,Object? halaqohId = null,Object? tanggalSetoran = null,Object? jenis = null,Object? surahId = null,Object? surahName = null,Object? ayatMulai = null,Object? ayatSelesai = null,Object? juz = null,Object? nilaiKelancaran = null,Object? nilaiTajwid = null,Object? createdAt = null,Object? isSynced = null,Object? notifiedAt = freezed,}) {
  return _then(_HafalanSantriModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,halaqohId: null == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String,tanggalSetoran: null == tanggalSetoran ? _self.tanggalSetoran : tanggalSetoran // ignore: cast_nullable_to_non_nullable
as DateTime,jenis: null == jenis ? _self.jenis : jenis // ignore: cast_nullable_to_non_nullable
as String,surahId: null == surahId ? _self.surahId : surahId // ignore: cast_nullable_to_non_nullable
as int,surahName: null == surahName ? _self.surahName : surahName // ignore: cast_nullable_to_non_nullable
as String,ayatMulai: null == ayatMulai ? _self.ayatMulai : ayatMulai // ignore: cast_nullable_to_non_nullable
as int,ayatSelesai: null == ayatSelesai ? _self.ayatSelesai : ayatSelesai // ignore: cast_nullable_to_non_nullable
as int,juz: null == juz ? _self.juz : juz // ignore: cast_nullable_to_non_nullable
as int,nilaiKelancaran: null == nilaiKelancaran ? _self.nilaiKelancaran : nilaiKelancaran // ignore: cast_nullable_to_non_nullable
as int,nilaiTajwid: null == nilaiTajwid ? _self.nilaiTajwid : nilaiTajwid // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,notifiedAt: freezed == notifiedAt ? _self.notifiedAt : notifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
