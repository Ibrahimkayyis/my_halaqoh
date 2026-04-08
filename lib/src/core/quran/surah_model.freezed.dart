// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surah_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SurahModel {

 int get id; String get name;@JsonKey(name: 'name_ar') String get nameAr;@JsonKey(name: 'ayat_count') int get ayatCount;@JsonKey(name: 'juz_start') int get juzStart;/// Each entry maps this surah to a juz: {juz, ayat_start, ayat_end}
@JsonKey(name: 'juz_mappings') List<JuzSegmentModel> get juzMappings;
/// Create a copy of SurahModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurahModelCopyWith<SurahModel> get copyWith => _$SurahModelCopyWithImpl<SurahModel>(this as SurahModel, _$identity);

  /// Serializes this SurahModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurahModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.ayatCount, ayatCount) || other.ayatCount == ayatCount)&&(identical(other.juzStart, juzStart) || other.juzStart == juzStart)&&const DeepCollectionEquality().equals(other.juzMappings, juzMappings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,ayatCount,juzStart,const DeepCollectionEquality().hash(juzMappings));

@override
String toString() {
  return 'SurahModel(id: $id, name: $name, nameAr: $nameAr, ayatCount: $ayatCount, juzStart: $juzStart, juzMappings: $juzMappings)';
}


}

/// @nodoc
abstract mixin class $SurahModelCopyWith<$Res>  {
  factory $SurahModelCopyWith(SurahModel value, $Res Function(SurahModel) _then) = _$SurahModelCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'ayat_count') int ayatCount,@JsonKey(name: 'juz_start') int juzStart,@JsonKey(name: 'juz_mappings') List<JuzSegmentModel> juzMappings
});




}
/// @nodoc
class _$SurahModelCopyWithImpl<$Res>
    implements $SurahModelCopyWith<$Res> {
  _$SurahModelCopyWithImpl(this._self, this._then);

  final SurahModel _self;
  final $Res Function(SurahModel) _then;

/// Create a copy of SurahModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? ayatCount = null,Object? juzStart = null,Object? juzMappings = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,ayatCount: null == ayatCount ? _self.ayatCount : ayatCount // ignore: cast_nullable_to_non_nullable
as int,juzStart: null == juzStart ? _self.juzStart : juzStart // ignore: cast_nullable_to_non_nullable
as int,juzMappings: null == juzMappings ? _self.juzMappings : juzMappings // ignore: cast_nullable_to_non_nullable
as List<JuzSegmentModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SurahModel].
extension SurahModelPatterns on SurahModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurahModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurahModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurahModel value)  $default,){
final _that = this;
switch (_that) {
case _SurahModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurahModel value)?  $default,){
final _that = this;
switch (_that) {
case _SurahModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'ayat_count')  int ayatCount, @JsonKey(name: 'juz_start')  int juzStart, @JsonKey(name: 'juz_mappings')  List<JuzSegmentModel> juzMappings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurahModel() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.ayatCount,_that.juzStart,_that.juzMappings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'ayat_count')  int ayatCount, @JsonKey(name: 'juz_start')  int juzStart, @JsonKey(name: 'juz_mappings')  List<JuzSegmentModel> juzMappings)  $default,) {final _that = this;
switch (_that) {
case _SurahModel():
return $default(_that.id,_that.name,_that.nameAr,_that.ayatCount,_that.juzStart,_that.juzMappings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'name_ar')  String nameAr, @JsonKey(name: 'ayat_count')  int ayatCount, @JsonKey(name: 'juz_start')  int juzStart, @JsonKey(name: 'juz_mappings')  List<JuzSegmentModel> juzMappings)?  $default,) {final _that = this;
switch (_that) {
case _SurahModel() when $default != null:
return $default(_that.id,_that.name,_that.nameAr,_that.ayatCount,_that.juzStart,_that.juzMappings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SurahModel extends SurahModel {
  const _SurahModel({required this.id, required this.name, @JsonKey(name: 'name_ar') required this.nameAr, @JsonKey(name: 'ayat_count') required this.ayatCount, @JsonKey(name: 'juz_start') required this.juzStart, @JsonKey(name: 'juz_mappings') required final  List<JuzSegmentModel> juzMappings}): _juzMappings = juzMappings,super._();
  factory _SurahModel.fromJson(Map<String, dynamic> json) => _$SurahModelFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'name_ar') final  String nameAr;
@override@JsonKey(name: 'ayat_count') final  int ayatCount;
@override@JsonKey(name: 'juz_start') final  int juzStart;
/// Each entry maps this surah to a juz: {juz, ayat_start, ayat_end}
 final  List<JuzSegmentModel> _juzMappings;
/// Each entry maps this surah to a juz: {juz, ayat_start, ayat_end}
@override@JsonKey(name: 'juz_mappings') List<JuzSegmentModel> get juzMappings {
  if (_juzMappings is EqualUnmodifiableListView) return _juzMappings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_juzMappings);
}


/// Create a copy of SurahModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurahModelCopyWith<_SurahModel> get copyWith => __$SurahModelCopyWithImpl<_SurahModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SurahModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurahModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameAr, nameAr) || other.nameAr == nameAr)&&(identical(other.ayatCount, ayatCount) || other.ayatCount == ayatCount)&&(identical(other.juzStart, juzStart) || other.juzStart == juzStart)&&const DeepCollectionEquality().equals(other._juzMappings, _juzMappings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameAr,ayatCount,juzStart,const DeepCollectionEquality().hash(_juzMappings));

@override
String toString() {
  return 'SurahModel(id: $id, name: $name, nameAr: $nameAr, ayatCount: $ayatCount, juzStart: $juzStart, juzMappings: $juzMappings)';
}


}

/// @nodoc
abstract mixin class _$SurahModelCopyWith<$Res> implements $SurahModelCopyWith<$Res> {
  factory _$SurahModelCopyWith(_SurahModel value, $Res Function(_SurahModel) _then) = __$SurahModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'name_ar') String nameAr,@JsonKey(name: 'ayat_count') int ayatCount,@JsonKey(name: 'juz_start') int juzStart,@JsonKey(name: 'juz_mappings') List<JuzSegmentModel> juzMappings
});




}
/// @nodoc
class __$SurahModelCopyWithImpl<$Res>
    implements _$SurahModelCopyWith<$Res> {
  __$SurahModelCopyWithImpl(this._self, this._then);

  final _SurahModel _self;
  final $Res Function(_SurahModel) _then;

/// Create a copy of SurahModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameAr = null,Object? ayatCount = null,Object? juzStart = null,Object? juzMappings = null,}) {
  return _then(_SurahModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameAr: null == nameAr ? _self.nameAr : nameAr // ignore: cast_nullable_to_non_nullable
as String,ayatCount: null == ayatCount ? _self.ayatCount : ayatCount // ignore: cast_nullable_to_non_nullable
as int,juzStart: null == juzStart ? _self.juzStart : juzStart // ignore: cast_nullable_to_non_nullable
as int,juzMappings: null == juzMappings ? _self._juzMappings : juzMappings // ignore: cast_nullable_to_non_nullable
as List<JuzSegmentModel>,
  ));
}


}

// dart format on
