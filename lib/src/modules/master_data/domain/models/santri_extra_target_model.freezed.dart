// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'santri_extra_target_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SantriExtraTargetModel {

/// Santri document ID — also the Firestore document ID.
 String get santriId;/// Juz numbers added by the teacher. May be empty.
 List<int> get extraJuz; DateTime get updatedAt;
/// Create a copy of SantriExtraTargetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SantriExtraTargetModelCopyWith<SantriExtraTargetModel> get copyWith => _$SantriExtraTargetModelCopyWithImpl<SantriExtraTargetModel>(this as SantriExtraTargetModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SantriExtraTargetModel&&(identical(other.santriId, santriId) || other.santriId == santriId)&&const DeepCollectionEquality().equals(other.extraJuz, extraJuz)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,santriId,const DeepCollectionEquality().hash(extraJuz),updatedAt);

@override
String toString() {
  return 'SantriExtraTargetModel(santriId: $santriId, extraJuz: $extraJuz, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SantriExtraTargetModelCopyWith<$Res>  {
  factory $SantriExtraTargetModelCopyWith(SantriExtraTargetModel value, $Res Function(SantriExtraTargetModel) _then) = _$SantriExtraTargetModelCopyWithImpl;
@useResult
$Res call({
 String santriId, List<int> extraJuz, DateTime updatedAt
});




}
/// @nodoc
class _$SantriExtraTargetModelCopyWithImpl<$Res>
    implements $SantriExtraTargetModelCopyWith<$Res> {
  _$SantriExtraTargetModelCopyWithImpl(this._self, this._then);

  final SantriExtraTargetModel _self;
  final $Res Function(SantriExtraTargetModel) _then;

/// Create a copy of SantriExtraTargetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? santriId = null,Object? extraJuz = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,extraJuz: null == extraJuz ? _self.extraJuz : extraJuz // ignore: cast_nullable_to_non_nullable
as List<int>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SantriExtraTargetModel].
extension SantriExtraTargetModelPatterns on SantriExtraTargetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SantriExtraTargetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SantriExtraTargetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SantriExtraTargetModel value)  $default,){
final _that = this;
switch (_that) {
case _SantriExtraTargetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SantriExtraTargetModel value)?  $default,){
final _that = this;
switch (_that) {
case _SantriExtraTargetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String santriId,  List<int> extraJuz,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SantriExtraTargetModel() when $default != null:
return $default(_that.santriId,_that.extraJuz,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String santriId,  List<int> extraJuz,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SantriExtraTargetModel():
return $default(_that.santriId,_that.extraJuz,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String santriId,  List<int> extraJuz,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SantriExtraTargetModel() when $default != null:
return $default(_that.santriId,_that.extraJuz,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SantriExtraTargetModel implements SantriExtraTargetModel {
  const _SantriExtraTargetModel({required this.santriId, final  List<int> extraJuz = const [], required this.updatedAt}): _extraJuz = extraJuz;
  

/// Santri document ID — also the Firestore document ID.
@override final  String santriId;
/// Juz numbers added by the teacher. May be empty.
 final  List<int> _extraJuz;
/// Juz numbers added by the teacher. May be empty.
@override@JsonKey() List<int> get extraJuz {
  if (_extraJuz is EqualUnmodifiableListView) return _extraJuz;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraJuz);
}

@override final  DateTime updatedAt;

/// Create a copy of SantriExtraTargetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SantriExtraTargetModelCopyWith<_SantriExtraTargetModel> get copyWith => __$SantriExtraTargetModelCopyWithImpl<_SantriExtraTargetModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SantriExtraTargetModel&&(identical(other.santriId, santriId) || other.santriId == santriId)&&const DeepCollectionEquality().equals(other._extraJuz, _extraJuz)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,santriId,const DeepCollectionEquality().hash(_extraJuz),updatedAt);

@override
String toString() {
  return 'SantriExtraTargetModel(santriId: $santriId, extraJuz: $extraJuz, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SantriExtraTargetModelCopyWith<$Res> implements $SantriExtraTargetModelCopyWith<$Res> {
  factory _$SantriExtraTargetModelCopyWith(_SantriExtraTargetModel value, $Res Function(_SantriExtraTargetModel) _then) = __$SantriExtraTargetModelCopyWithImpl;
@override @useResult
$Res call({
 String santriId, List<int> extraJuz, DateTime updatedAt
});




}
/// @nodoc
class __$SantriExtraTargetModelCopyWithImpl<$Res>
    implements _$SantriExtraTargetModelCopyWith<$Res> {
  __$SantriExtraTargetModelCopyWithImpl(this._self, this._then);

  final _SantriExtraTargetModel _self;
  final $Res Function(_SantriExtraTargetModel) _then;

/// Create a copy of SantriExtraTargetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? santriId = null,Object? extraJuz = null,Object? updatedAt = null,}) {
  return _then(_SantriExtraTargetModel(
santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,extraJuz: null == extraJuz ? _self._extraJuz : extraJuz // ignore: cast_nullable_to_non_nullable
as List<int>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
