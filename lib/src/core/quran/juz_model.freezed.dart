// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'juz_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JuzModel {

 int get number;@JsonKey(name: 'total_ayat') int get totalAyat; List<JuzSegmentModel> get surahs;
/// Create a copy of JuzModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JuzModelCopyWith<JuzModel> get copyWith => _$JuzModelCopyWithImpl<JuzModel>(this as JuzModel, _$identity);

  /// Serializes this JuzModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JuzModel&&(identical(other.number, number) || other.number == number)&&(identical(other.totalAyat, totalAyat) || other.totalAyat == totalAyat)&&const DeepCollectionEquality().equals(other.surahs, surahs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,totalAyat,const DeepCollectionEquality().hash(surahs));

@override
String toString() {
  return 'JuzModel(number: $number, totalAyat: $totalAyat, surahs: $surahs)';
}


}

/// @nodoc
abstract mixin class $JuzModelCopyWith<$Res>  {
  factory $JuzModelCopyWith(JuzModel value, $Res Function(JuzModel) _then) = _$JuzModelCopyWithImpl;
@useResult
$Res call({
 int number,@JsonKey(name: 'total_ayat') int totalAyat, List<JuzSegmentModel> surahs
});




}
/// @nodoc
class _$JuzModelCopyWithImpl<$Res>
    implements $JuzModelCopyWith<$Res> {
  _$JuzModelCopyWithImpl(this._self, this._then);

  final JuzModel _self;
  final $Res Function(JuzModel) _then;

/// Create a copy of JuzModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? totalAyat = null,Object? surahs = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,totalAyat: null == totalAyat ? _self.totalAyat : totalAyat // ignore: cast_nullable_to_non_nullable
as int,surahs: null == surahs ? _self.surahs : surahs // ignore: cast_nullable_to_non_nullable
as List<JuzSegmentModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [JuzModel].
extension JuzModelPatterns on JuzModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JuzModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JuzModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JuzModel value)  $default,){
final _that = this;
switch (_that) {
case _JuzModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JuzModel value)?  $default,){
final _that = this;
switch (_that) {
case _JuzModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int number, @JsonKey(name: 'total_ayat')  int totalAyat,  List<JuzSegmentModel> surahs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JuzModel() when $default != null:
return $default(_that.number,_that.totalAyat,_that.surahs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int number, @JsonKey(name: 'total_ayat')  int totalAyat,  List<JuzSegmentModel> surahs)  $default,) {final _that = this;
switch (_that) {
case _JuzModel():
return $default(_that.number,_that.totalAyat,_that.surahs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int number, @JsonKey(name: 'total_ayat')  int totalAyat,  List<JuzSegmentModel> surahs)?  $default,) {final _that = this;
switch (_that) {
case _JuzModel() when $default != null:
return $default(_that.number,_that.totalAyat,_that.surahs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JuzModel extends JuzModel {
  const _JuzModel({required this.number, @JsonKey(name: 'total_ayat') required this.totalAyat, required final  List<JuzSegmentModel> surahs}): _surahs = surahs,super._();
  factory _JuzModel.fromJson(Map<String, dynamic> json) => _$JuzModelFromJson(json);

@override final  int number;
@override@JsonKey(name: 'total_ayat') final  int totalAyat;
 final  List<JuzSegmentModel> _surahs;
@override List<JuzSegmentModel> get surahs {
  if (_surahs is EqualUnmodifiableListView) return _surahs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_surahs);
}


/// Create a copy of JuzModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JuzModelCopyWith<_JuzModel> get copyWith => __$JuzModelCopyWithImpl<_JuzModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JuzModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JuzModel&&(identical(other.number, number) || other.number == number)&&(identical(other.totalAyat, totalAyat) || other.totalAyat == totalAyat)&&const DeepCollectionEquality().equals(other._surahs, _surahs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,totalAyat,const DeepCollectionEquality().hash(_surahs));

@override
String toString() {
  return 'JuzModel(number: $number, totalAyat: $totalAyat, surahs: $surahs)';
}


}

/// @nodoc
abstract mixin class _$JuzModelCopyWith<$Res> implements $JuzModelCopyWith<$Res> {
  factory _$JuzModelCopyWith(_JuzModel value, $Res Function(_JuzModel) _then) = __$JuzModelCopyWithImpl;
@override @useResult
$Res call({
 int number,@JsonKey(name: 'total_ayat') int totalAyat, List<JuzSegmentModel> surahs
});




}
/// @nodoc
class __$JuzModelCopyWithImpl<$Res>
    implements _$JuzModelCopyWith<$Res> {
  __$JuzModelCopyWithImpl(this._self, this._then);

  final _JuzModel _self;
  final $Res Function(_JuzModel) _then;

/// Create a copy of JuzModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? totalAyat = null,Object? surahs = null,}) {
  return _then(_JuzModel(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,totalAyat: null == totalAyat ? _self.totalAyat : totalAyat // ignore: cast_nullable_to_non_nullable
as int,surahs: null == surahs ? _self._surahs : surahs // ignore: cast_nullable_to_non_nullable
as List<JuzSegmentModel>,
  ));
}


}

// dart format on
