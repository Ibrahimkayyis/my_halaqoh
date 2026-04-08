// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'halaqoh_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HalaqohModel {

/// Firestore document ID
 String get id;/// Free-text name, e.g. "AL FATIH 1"
 String get nama;/// Class level: "7", "8", ..., "12"
 String get kelas;/// Program type: "R" (Reguler) or "T" (Takhassus)
 String get program;/// Reference to guru document ID
 String get guruId;/// Denormalized guru name for display without extra query
 String get guruNama;/// List of santri document IDs in this halaqoh
 List<String> get santriIds;/// Denormalized santri count
 int get jumlahSantri; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of HalaqohModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HalaqohModelCopyWith<HalaqohModel> get copyWith => _$HalaqohModelCopyWithImpl<HalaqohModel>(this as HalaqohModel, _$identity);

  /// Serializes this HalaqohModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HalaqohModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&const DeepCollectionEquality().equals(other.santriIds, santriIds)&&(identical(other.jumlahSantri, jumlahSantri) || other.jumlahSantri == jumlahSantri)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,kelas,program,guruId,guruNama,const DeepCollectionEquality().hash(santriIds),jumlahSantri,createdAt,updatedAt);

@override
String toString() {
  return 'HalaqohModel(id: $id, nama: $nama, kelas: $kelas, program: $program, guruId: $guruId, guruNama: $guruNama, santriIds: $santriIds, jumlahSantri: $jumlahSantri, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HalaqohModelCopyWith<$Res>  {
  factory $HalaqohModelCopyWith(HalaqohModel value, $Res Function(HalaqohModel) _then) = _$HalaqohModelCopyWithImpl;
@useResult
$Res call({
 String id, String nama, String kelas, String program, String guruId, String guruNama, List<String> santriIds, int jumlahSantri, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$HalaqohModelCopyWithImpl<$Res>
    implements $HalaqohModelCopyWith<$Res> {
  _$HalaqohModelCopyWithImpl(this._self, this._then);

  final HalaqohModel _self;
  final $Res Function(HalaqohModel) _then;

/// Create a copy of HalaqohModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nama = null,Object? kelas = null,Object? program = null,Object? guruId = null,Object? guruNama = null,Object? santriIds = null,Object? jumlahSantri = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,santriIds: null == santriIds ? _self.santriIds : santriIds // ignore: cast_nullable_to_non_nullable
as List<String>,jumlahSantri: null == jumlahSantri ? _self.jumlahSantri : jumlahSantri // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HalaqohModel].
extension HalaqohModelPatterns on HalaqohModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HalaqohModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HalaqohModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HalaqohModel value)  $default,){
final _that = this;
switch (_that) {
case _HalaqohModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HalaqohModel value)?  $default,){
final _that = this;
switch (_that) {
case _HalaqohModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nama,  String kelas,  String program,  String guruId,  String guruNama,  List<String> santriIds,  int jumlahSantri,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HalaqohModel() when $default != null:
return $default(_that.id,_that.nama,_that.kelas,_that.program,_that.guruId,_that.guruNama,_that.santriIds,_that.jumlahSantri,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nama,  String kelas,  String program,  String guruId,  String guruNama,  List<String> santriIds,  int jumlahSantri,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _HalaqohModel():
return $default(_that.id,_that.nama,_that.kelas,_that.program,_that.guruId,_that.guruNama,_that.santriIds,_that.jumlahSantri,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nama,  String kelas,  String program,  String guruId,  String guruNama,  List<String> santriIds,  int jumlahSantri,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HalaqohModel() when $default != null:
return $default(_that.id,_that.nama,_that.kelas,_that.program,_that.guruId,_that.guruNama,_that.santriIds,_that.jumlahSantri,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HalaqohModel implements HalaqohModel {
  const _HalaqohModel({required this.id, required this.nama, required this.kelas, required this.program, required this.guruId, required this.guruNama, final  List<String> santriIds = const [], this.jumlahSantri = 0, required this.createdAt, required this.updatedAt}): _santriIds = santriIds;
  factory _HalaqohModel.fromJson(Map<String, dynamic> json) => _$HalaqohModelFromJson(json);

/// Firestore document ID
@override final  String id;
/// Free-text name, e.g. "AL FATIH 1"
@override final  String nama;
/// Class level: "7", "8", ..., "12"
@override final  String kelas;
/// Program type: "R" (Reguler) or "T" (Takhassus)
@override final  String program;
/// Reference to guru document ID
@override final  String guruId;
/// Denormalized guru name for display without extra query
@override final  String guruNama;
/// List of santri document IDs in this halaqoh
 final  List<String> _santriIds;
/// List of santri document IDs in this halaqoh
@override@JsonKey() List<String> get santriIds {
  if (_santriIds is EqualUnmodifiableListView) return _santriIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_santriIds);
}

/// Denormalized santri count
@override@JsonKey() final  int jumlahSantri;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of HalaqohModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HalaqohModelCopyWith<_HalaqohModel> get copyWith => __$HalaqohModelCopyWithImpl<_HalaqohModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HalaqohModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HalaqohModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.kelas, kelas) || other.kelas == kelas)&&(identical(other.program, program) || other.program == program)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.guruNama, guruNama) || other.guruNama == guruNama)&&const DeepCollectionEquality().equals(other._santriIds, _santriIds)&&(identical(other.jumlahSantri, jumlahSantri) || other.jumlahSantri == jumlahSantri)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,kelas,program,guruId,guruNama,const DeepCollectionEquality().hash(_santriIds),jumlahSantri,createdAt,updatedAt);

@override
String toString() {
  return 'HalaqohModel(id: $id, nama: $nama, kelas: $kelas, program: $program, guruId: $guruId, guruNama: $guruNama, santriIds: $santriIds, jumlahSantri: $jumlahSantri, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HalaqohModelCopyWith<$Res> implements $HalaqohModelCopyWith<$Res> {
  factory _$HalaqohModelCopyWith(_HalaqohModel value, $Res Function(_HalaqohModel) _then) = __$HalaqohModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String nama, String kelas, String program, String guruId, String guruNama, List<String> santriIds, int jumlahSantri, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$HalaqohModelCopyWithImpl<$Res>
    implements _$HalaqohModelCopyWith<$Res> {
  __$HalaqohModelCopyWithImpl(this._self, this._then);

  final _HalaqohModel _self;
  final $Res Function(_HalaqohModel) _then;

/// Create a copy of HalaqohModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nama = null,Object? kelas = null,Object? program = null,Object? guruId = null,Object? guruNama = null,Object? santriIds = null,Object? jumlahSantri = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_HalaqohModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,kelas: null == kelas ? _self.kelas : kelas // ignore: cast_nullable_to_non_nullable
as String,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,guruNama: null == guruNama ? _self.guruNama : guruNama // ignore: cast_nullable_to_non_nullable
as String,santriIds: null == santriIds ? _self._santriIds : santriIds // ignore: cast_nullable_to_non_nullable
as List<String>,jumlahSantri: null == jumlahSantri ? _self.jumlahSantri : jumlahSantri // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
