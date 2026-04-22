// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guru_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuruModel {

/// Firestore document ID
 String get id;/// NIP — 13 digit unique identifier, also used for login
 String get nip;/// Full name, e.g. "Ustadz Ahmad Fauzi, S.Pd.I"
 String get nama;/// Phone number (Optional)
 String? get phone;/// Profile picture URL (Optional)
 String? get profilePicture;/// Personal/contact email address (Optional, separate from Auth email)
 String? get email;/// Program type: "R" (Reguler) or "T" (Takhassus)
 String get program;/// Firebase Auth UID (nullable — set after auth account is created)
 String? get authUid; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of GuruModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuruModelCopyWith<GuruModel> get copyWith => _$GuruModelCopyWithImpl<GuruModel>(this as GuruModel, _$identity);

  /// Serializes this GuruModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuruModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nip, nip) || other.nip == nip)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.email, email) || other.email == email)&&(identical(other.program, program) || other.program == program)&&(identical(other.authUid, authUid) || other.authUid == authUid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nip,nama,phone,profilePicture,email,program,authUid,createdAt,updatedAt);

@override
String toString() {
  return 'GuruModel(id: $id, nip: $nip, nama: $nama, phone: $phone, profilePicture: $profilePicture, email: $email, program: $program, authUid: $authUid, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $GuruModelCopyWith<$Res>  {
  factory $GuruModelCopyWith(GuruModel value, $Res Function(GuruModel) _then) = _$GuruModelCopyWithImpl;
@useResult
$Res call({
 String id, String nip, String nama, String? phone, String? profilePicture, String? email, String program, String? authUid, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$GuruModelCopyWithImpl<$Res>
    implements $GuruModelCopyWith<$Res> {
  _$GuruModelCopyWithImpl(this._self, this._then);

  final GuruModel _self;
  final $Res Function(GuruModel) _then;

/// Create a copy of GuruModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nip = null,Object? nama = null,Object? phone = freezed,Object? profilePicture = freezed,Object? email = freezed,Object? program = null,Object? authUid = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nip: null == nip ? _self.nip : nip // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,authUid: freezed == authUid ? _self.authUid : authUid // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GuruModel].
extension GuruModelPatterns on GuruModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuruModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuruModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuruModel value)  $default,){
final _that = this;
switch (_that) {
case _GuruModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuruModel value)?  $default,){
final _that = this;
switch (_that) {
case _GuruModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nip,  String nama,  String? phone,  String? profilePicture,  String? email,  String program,  String? authUid,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuruModel() when $default != null:
return $default(_that.id,_that.nip,_that.nama,_that.phone,_that.profilePicture,_that.email,_that.program,_that.authUid,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nip,  String nama,  String? phone,  String? profilePicture,  String? email,  String program,  String? authUid,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _GuruModel():
return $default(_that.id,_that.nip,_that.nama,_that.phone,_that.profilePicture,_that.email,_that.program,_that.authUid,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nip,  String nama,  String? phone,  String? profilePicture,  String? email,  String program,  String? authUid,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _GuruModel() when $default != null:
return $default(_that.id,_that.nip,_that.nama,_that.phone,_that.profilePicture,_that.email,_that.program,_that.authUid,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GuruModel implements GuruModel {
  const _GuruModel({required this.id, required this.nip, required this.nama, this.phone, this.profilePicture, this.email, required this.program, this.authUid, required this.createdAt, required this.updatedAt});
  factory _GuruModel.fromJson(Map<String, dynamic> json) => _$GuruModelFromJson(json);

/// Firestore document ID
@override final  String id;
/// NIP — 13 digit unique identifier, also used for login
@override final  String nip;
/// Full name, e.g. "Ustadz Ahmad Fauzi, S.Pd.I"
@override final  String nama;
/// Phone number (Optional)
@override final  String? phone;
/// Profile picture URL (Optional)
@override final  String? profilePicture;
/// Personal/contact email address (Optional, separate from Auth email)
@override final  String? email;
/// Program type: "R" (Reguler) or "T" (Takhassus)
@override final  String program;
/// Firebase Auth UID (nullable — set after auth account is created)
@override final  String? authUid;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of GuruModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuruModelCopyWith<_GuruModel> get copyWith => __$GuruModelCopyWithImpl<_GuruModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuruModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuruModel&&(identical(other.id, id) || other.id == id)&&(identical(other.nip, nip) || other.nip == nip)&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.email, email) || other.email == email)&&(identical(other.program, program) || other.program == program)&&(identical(other.authUid, authUid) || other.authUid == authUid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nip,nama,phone,profilePicture,email,program,authUid,createdAt,updatedAt);

@override
String toString() {
  return 'GuruModel(id: $id, nip: $nip, nama: $nama, phone: $phone, profilePicture: $profilePicture, email: $email, program: $program, authUid: $authUid, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$GuruModelCopyWith<$Res> implements $GuruModelCopyWith<$Res> {
  factory _$GuruModelCopyWith(_GuruModel value, $Res Function(_GuruModel) _then) = __$GuruModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String nip, String nama, String? phone, String? profilePicture, String? email, String program, String? authUid, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$GuruModelCopyWithImpl<$Res>
    implements _$GuruModelCopyWith<$Res> {
  __$GuruModelCopyWithImpl(this._self, this._then);

  final _GuruModel _self;
  final $Res Function(_GuruModel) _then;

/// Create a copy of GuruModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nip = null,Object? nama = null,Object? phone = freezed,Object? profilePicture = freezed,Object? email = freezed,Object? program = null,Object? authUid = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_GuruModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nip: null == nip ? _self.nip : nip // ignore: cast_nullable_to_non_nullable
as String,nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as String,authUid: freezed == authUid ? _self.authUid : authUid // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
