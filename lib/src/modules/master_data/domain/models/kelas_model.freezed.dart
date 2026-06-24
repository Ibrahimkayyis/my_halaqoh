// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kelas_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KelasModel {

 String get id;// unique ID (e.g., '7', '8', dll)
 String get nama;// e.g., '7', '8', '9'
 int get urutan;// tingkat/urutan kelas
 String? get nextKelasId;// ID kelas berikutnya (null = alumni/lulus)
 DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of KelasModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KelasModelCopyWith<KelasModel> get copyWith => _$KelasModelCopyWithImpl<KelasModel>(this as KelasModel, _$identity);

  /// Serializes this KelasModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KelasModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.urutan, urutan) || other.urutan == urutan)&&(identical(other.nextKelasId, nextKelasId) || other.nextKelasId == nextKelasId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,urutan,nextKelasId,createdAt,updatedAt);

@override
String toString() {
  return 'KelasModel(id: $id, nama: $nama, urutan: $urutan, nextKelasId: $nextKelasId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $KelasModelCopyWith<$Res>  {
  factory $KelasModelCopyWith(KelasModel value, $Res Function(KelasModel) _then) = _$KelasModelCopyWithImpl;
@useResult
$Res call({
 String id, String nama, int urutan, String? nextKelasId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$KelasModelCopyWithImpl<$Res>
    implements $KelasModelCopyWith<$Res> {
  _$KelasModelCopyWithImpl(this._self, this._then);

  final KelasModel _self;
  final $Res Function(KelasModel) _then;

/// Create a copy of KelasModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nama = null,Object? urutan = null,Object? nextKelasId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,urutan: null == urutan ? _self.urutan : urutan // ignore: cast_nullable_to_non_nullable
as int,nextKelasId: freezed == nextKelasId ? _self.nextKelasId : nextKelasId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KelasModel].
extension KelasModelPatterns on KelasModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KelasModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KelasModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KelasModel value)  $default,){
final _that = this;
switch (_that) {
case _KelasModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KelasModel value)?  $default,){
final _that = this;
switch (_that) {
case _KelasModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nama,  int urutan,  String? nextKelasId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KelasModel() when $default != null:
return $default(_that.id,_that.nama,_that.urutan,_that.nextKelasId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nama,  int urutan,  String? nextKelasId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _KelasModel():
return $default(_that.id,_that.nama,_that.urutan,_that.nextKelasId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nama,  int urutan,  String? nextKelasId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _KelasModel() when $default != null:
return $default(_that.id,_that.nama,_that.urutan,_that.nextKelasId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KelasModel implements KelasModel {
  const _KelasModel({required this.id, required this.nama, required this.urutan, this.nextKelasId, required this.createdAt, required this.updatedAt});
  factory _KelasModel.fromJson(Map<String, dynamic> json) => _$KelasModelFromJson(json);

@override final  String id;
// unique ID (e.g., '7', '8', dll)
@override final  String nama;
// e.g., '7', '8', '9'
@override final  int urutan;
// tingkat/urutan kelas
@override final  String? nextKelasId;
// ID kelas berikutnya (null = alumni/lulus)
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of KelasModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KelasModelCopyWith<_KelasModel> get copyWith => __$KelasModelCopyWithImpl<_KelasModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KelasModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KelasModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.urutan, urutan) || other.urutan == urutan)&&(identical(other.nextKelasId, nextKelasId) || other.nextKelasId == nextKelasId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nama,urutan,nextKelasId,createdAt,updatedAt);

@override
String toString() {
  return 'KelasModel(id: $id, nama: $nama, urutan: $urutan, nextKelasId: $nextKelasId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$KelasModelCopyWith<$Res> implements $KelasModelCopyWith<$Res> {
  factory _$KelasModelCopyWith(_KelasModel value, $Res Function(_KelasModel) _then) = __$KelasModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String nama, int urutan, String? nextKelasId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$KelasModelCopyWithImpl<$Res>
    implements _$KelasModelCopyWith<$Res> {
  __$KelasModelCopyWithImpl(this._self, this._then);

  final _KelasModel _self;
  final $Res Function(_KelasModel) _then;

/// Create a copy of KelasModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nama = null,Object? urutan = null,Object? nextKelasId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_KelasModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,urutan: null == urutan ? _self.urutan : urutan // ignore: cast_nullable_to_non_nullable
as int,nextKelasId: freezed == nextKelasId ? _self.nextKelasId : nextKelasId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
