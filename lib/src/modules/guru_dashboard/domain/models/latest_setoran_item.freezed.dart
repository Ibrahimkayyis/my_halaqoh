// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'latest_setoran_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LatestSetoranItem {

 String get santriId; String get santriName; DateTime get tanggalSetoran; String get jenis;// "Ziyadah" or "Murajaah"
 int get nilaiKelancaran; int get nilaiTajwid; List<HafalanSantriModel> get records;
/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestSetoranItemCopyWith<LatestSetoranItem> get copyWith => _$LatestSetoranItemCopyWithImpl<LatestSetoranItem>(this as LatestSetoranItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestSetoranItem&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.santriName, santriName) || other.santriName == santriName)&&(identical(other.tanggalSetoran, tanggalSetoran) || other.tanggalSetoran == tanggalSetoran)&&(identical(other.jenis, jenis) || other.jenis == jenis)&&(identical(other.nilaiKelancaran, nilaiKelancaran) || other.nilaiKelancaran == nilaiKelancaran)&&(identical(other.nilaiTajwid, nilaiTajwid) || other.nilaiTajwid == nilaiTajwid)&&const DeepCollectionEquality().equals(other.records, records));
}


@override
int get hashCode => Object.hash(runtimeType,santriId,santriName,tanggalSetoran,jenis,nilaiKelancaran,nilaiTajwid,const DeepCollectionEquality().hash(records));

@override
String toString() {
  return 'LatestSetoranItem(santriId: $santriId, santriName: $santriName, tanggalSetoran: $tanggalSetoran, jenis: $jenis, nilaiKelancaran: $nilaiKelancaran, nilaiTajwid: $nilaiTajwid, records: $records)';
}


}

/// @nodoc
abstract mixin class $LatestSetoranItemCopyWith<$Res>  {
  factory $LatestSetoranItemCopyWith(LatestSetoranItem value, $Res Function(LatestSetoranItem) _then) = _$LatestSetoranItemCopyWithImpl;
@useResult
$Res call({
 String santriId, String santriName, DateTime tanggalSetoran, String jenis, int nilaiKelancaran, int nilaiTajwid, List<HafalanSantriModel> records
});




}
/// @nodoc
class _$LatestSetoranItemCopyWithImpl<$Res>
    implements $LatestSetoranItemCopyWith<$Res> {
  _$LatestSetoranItemCopyWithImpl(this._self, this._then);

  final LatestSetoranItem _self;
  final $Res Function(LatestSetoranItem) _then;

/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? santriId = null,Object? santriName = null,Object? tanggalSetoran = null,Object? jenis = null,Object? nilaiKelancaran = null,Object? nilaiTajwid = null,Object? records = null,}) {
  return _then(_self.copyWith(
santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,santriName: null == santriName ? _self.santriName : santriName // ignore: cast_nullable_to_non_nullable
as String,tanggalSetoran: null == tanggalSetoran ? _self.tanggalSetoran : tanggalSetoran // ignore: cast_nullable_to_non_nullable
as DateTime,jenis: null == jenis ? _self.jenis : jenis // ignore: cast_nullable_to_non_nullable
as String,nilaiKelancaran: null == nilaiKelancaran ? _self.nilaiKelancaran : nilaiKelancaran // ignore: cast_nullable_to_non_nullable
as int,nilaiTajwid: null == nilaiTajwid ? _self.nilaiTajwid : nilaiTajwid // ignore: cast_nullable_to_non_nullable
as int,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<HafalanSantriModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [LatestSetoranItem].
extension LatestSetoranItemPatterns on LatestSetoranItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LatestSetoranItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LatestSetoranItem value)  $default,){
final _that = this;
switch (_that) {
case _LatestSetoranItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LatestSetoranItem value)?  $default,){
final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String santriId,  String santriName,  DateTime tanggalSetoran,  String jenis,  int nilaiKelancaran,  int nilaiTajwid,  List<HafalanSantriModel> records)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
return $default(_that.santriId,_that.santriName,_that.tanggalSetoran,_that.jenis,_that.nilaiKelancaran,_that.nilaiTajwid,_that.records);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String santriId,  String santriName,  DateTime tanggalSetoran,  String jenis,  int nilaiKelancaran,  int nilaiTajwid,  List<HafalanSantriModel> records)  $default,) {final _that = this;
switch (_that) {
case _LatestSetoranItem():
return $default(_that.santriId,_that.santriName,_that.tanggalSetoran,_that.jenis,_that.nilaiKelancaran,_that.nilaiTajwid,_that.records);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String santriId,  String santriName,  DateTime tanggalSetoran,  String jenis,  int nilaiKelancaran,  int nilaiTajwid,  List<HafalanSantriModel> records)?  $default,) {final _that = this;
switch (_that) {
case _LatestSetoranItem() when $default != null:
return $default(_that.santriId,_that.santriName,_that.tanggalSetoran,_that.jenis,_that.nilaiKelancaran,_that.nilaiTajwid,_that.records);case _:
  return null;

}
}

}

/// @nodoc


class _LatestSetoranItem extends LatestSetoranItem {
  const _LatestSetoranItem({required this.santriId, required this.santriName, required this.tanggalSetoran, required this.jenis, required this.nilaiKelancaran, required this.nilaiTajwid, required final  List<HafalanSantriModel> records}): _records = records,super._();
  

@override final  String santriId;
@override final  String santriName;
@override final  DateTime tanggalSetoran;
@override final  String jenis;
// "Ziyadah" or "Murajaah"
@override final  int nilaiKelancaran;
@override final  int nilaiTajwid;
 final  List<HafalanSantriModel> _records;
@override List<HafalanSantriModel> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}


/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatestSetoranItemCopyWith<_LatestSetoranItem> get copyWith => __$LatestSetoranItemCopyWithImpl<_LatestSetoranItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LatestSetoranItem&&(identical(other.santriId, santriId) || other.santriId == santriId)&&(identical(other.santriName, santriName) || other.santriName == santriName)&&(identical(other.tanggalSetoran, tanggalSetoran) || other.tanggalSetoran == tanggalSetoran)&&(identical(other.jenis, jenis) || other.jenis == jenis)&&(identical(other.nilaiKelancaran, nilaiKelancaran) || other.nilaiKelancaran == nilaiKelancaran)&&(identical(other.nilaiTajwid, nilaiTajwid) || other.nilaiTajwid == nilaiTajwid)&&const DeepCollectionEquality().equals(other._records, _records));
}


@override
int get hashCode => Object.hash(runtimeType,santriId,santriName,tanggalSetoran,jenis,nilaiKelancaran,nilaiTajwid,const DeepCollectionEquality().hash(_records));

@override
String toString() {
  return 'LatestSetoranItem(santriId: $santriId, santriName: $santriName, tanggalSetoran: $tanggalSetoran, jenis: $jenis, nilaiKelancaran: $nilaiKelancaran, nilaiTajwid: $nilaiTajwid, records: $records)';
}


}

/// @nodoc
abstract mixin class _$LatestSetoranItemCopyWith<$Res> implements $LatestSetoranItemCopyWith<$Res> {
  factory _$LatestSetoranItemCopyWith(_LatestSetoranItem value, $Res Function(_LatestSetoranItem) _then) = __$LatestSetoranItemCopyWithImpl;
@override @useResult
$Res call({
 String santriId, String santriName, DateTime tanggalSetoran, String jenis, int nilaiKelancaran, int nilaiTajwid, List<HafalanSantriModel> records
});




}
/// @nodoc
class __$LatestSetoranItemCopyWithImpl<$Res>
    implements _$LatestSetoranItemCopyWith<$Res> {
  __$LatestSetoranItemCopyWithImpl(this._self, this._then);

  final _LatestSetoranItem _self;
  final $Res Function(_LatestSetoranItem) _then;

/// Create a copy of LatestSetoranItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? santriId = null,Object? santriName = null,Object? tanggalSetoran = null,Object? jenis = null,Object? nilaiKelancaran = null,Object? nilaiTajwid = null,Object? records = null,}) {
  return _then(_LatestSetoranItem(
santriId: null == santriId ? _self.santriId : santriId // ignore: cast_nullable_to_non_nullable
as String,santriName: null == santriName ? _self.santriName : santriName // ignore: cast_nullable_to_non_nullable
as String,tanggalSetoran: null == tanggalSetoran ? _self.tanggalSetoran : tanggalSetoran // ignore: cast_nullable_to_non_nullable
as DateTime,jenis: null == jenis ? _self.jenis : jenis // ignore: cast_nullable_to_non_nullable
as String,nilaiKelancaran: null == nilaiKelancaran ? _self.nilaiKelancaran : nilaiKelancaran // ignore: cast_nullable_to_non_nullable
as int,nilaiTajwid: null == nilaiTajwid ? _self.nilaiTajwid : nilaiTajwid // ignore: cast_nullable_to_non_nullable
as int,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<HafalanSantriModel>,
  ));
}


}

// dart format on
