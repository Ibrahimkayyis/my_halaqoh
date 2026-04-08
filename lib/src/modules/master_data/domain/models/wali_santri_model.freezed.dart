// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wali_santri_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaliSantriModel {

 String get nama; String get phone;/// "Ayah", "Ibu", or "Wali"
 String get hubungan;
/// Create a copy of WaliSantriModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaliSantriModelCopyWith<WaliSantriModel> get copyWith => _$WaliSantriModelCopyWithImpl<WaliSantriModel>(this as WaliSantriModel, _$identity);

  /// Serializes this WaliSantriModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaliSantriModel&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.hubungan, hubungan) || other.hubungan == hubungan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nama,phone,hubungan);

@override
String toString() {
  return 'WaliSantriModel(nama: $nama, phone: $phone, hubungan: $hubungan)';
}


}

/// @nodoc
abstract mixin class $WaliSantriModelCopyWith<$Res>  {
  factory $WaliSantriModelCopyWith(WaliSantriModel value, $Res Function(WaliSantriModel) _then) = _$WaliSantriModelCopyWithImpl;
@useResult
$Res call({
 String nama, String phone, String hubungan
});




}
/// @nodoc
class _$WaliSantriModelCopyWithImpl<$Res>
    implements $WaliSantriModelCopyWith<$Res> {
  _$WaliSantriModelCopyWithImpl(this._self, this._then);

  final WaliSantriModel _self;
  final $Res Function(WaliSantriModel) _then;

/// Create a copy of WaliSantriModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nama = null,Object? phone = null,Object? hubungan = null,}) {
  return _then(_self.copyWith(
nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,hubungan: null == hubungan ? _self.hubungan : hubungan // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WaliSantriModel].
extension WaliSantriModelPatterns on WaliSantriModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaliSantriModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaliSantriModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaliSantriModel value)  $default,){
final _that = this;
switch (_that) {
case _WaliSantriModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaliSantriModel value)?  $default,){
final _that = this;
switch (_that) {
case _WaliSantriModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nama,  String phone,  String hubungan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaliSantriModel() when $default != null:
return $default(_that.nama,_that.phone,_that.hubungan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nama,  String phone,  String hubungan)  $default,) {final _that = this;
switch (_that) {
case _WaliSantriModel():
return $default(_that.nama,_that.phone,_that.hubungan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nama,  String phone,  String hubungan)?  $default,) {final _that = this;
switch (_that) {
case _WaliSantriModel() when $default != null:
return $default(_that.nama,_that.phone,_that.hubungan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaliSantriModel implements WaliSantriModel {
  const _WaliSantriModel({required this.nama, required this.phone, required this.hubungan});
  factory _WaliSantriModel.fromJson(Map<String, dynamic> json) => _$WaliSantriModelFromJson(json);

@override final  String nama;
@override final  String phone;
/// "Ayah", "Ibu", or "Wali"
@override final  String hubungan;

/// Create a copy of WaliSantriModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaliSantriModelCopyWith<_WaliSantriModel> get copyWith => __$WaliSantriModelCopyWithImpl<_WaliSantriModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaliSantriModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaliSantriModel&&(identical(other.nama, nama) || other.nama == nama)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.hubungan, hubungan) || other.hubungan == hubungan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nama,phone,hubungan);

@override
String toString() {
  return 'WaliSantriModel(nama: $nama, phone: $phone, hubungan: $hubungan)';
}


}

/// @nodoc
abstract mixin class _$WaliSantriModelCopyWith<$Res> implements $WaliSantriModelCopyWith<$Res> {
  factory _$WaliSantriModelCopyWith(_WaliSantriModel value, $Res Function(_WaliSantriModel) _then) = __$WaliSantriModelCopyWithImpl;
@override @useResult
$Res call({
 String nama, String phone, String hubungan
});




}
/// @nodoc
class __$WaliSantriModelCopyWithImpl<$Res>
    implements _$WaliSantriModelCopyWith<$Res> {
  __$WaliSantriModelCopyWithImpl(this._self, this._then);

  final _WaliSantriModel _self;
  final $Res Function(_WaliSantriModel) _then;

/// Create a copy of WaliSantriModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nama = null,Object? phone = null,Object? hubungan = null,}) {
  return _then(_WaliSantriModel(
nama: null == nama ? _self.nama : nama // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,hubungan: null == hubungan ? _self.hubungan : hubungan // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
