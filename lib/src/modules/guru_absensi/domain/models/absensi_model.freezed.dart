// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'absensi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AbsensiModel {

/// Firestore document ID
 String get id;/// Reference to `/halaqoh/{id}`
 String get halaqohId;/// Reference to `/guru/{id}` — the teacher who recorded attendance
 String get guruId;/// Attendance date (date only, time portion is midnight)
 DateTime get tanggal;/// Session key: 'shubuh', 'dhuha1', 'dhuha2', 'ashar', 'maghrib'
 String get sesi;/// Per-student attendance entries
 List<AbsensiRecordEntry> get records;/// Whether this record has been synced to Firestore
 bool get isSynced; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AbsensiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbsensiModelCopyWith<AbsensiModel> get copyWith => _$AbsensiModelCopyWithImpl<AbsensiModel>(this as AbsensiModel, _$identity);

  /// Serializes this AbsensiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbsensiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.sesi, sesi) || other.sesi == sesi)&&const DeepCollectionEquality().equals(other.records, records)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,halaqohId,guruId,tanggal,sesi,const DeepCollectionEquality().hash(records),isSynced,createdAt,updatedAt);

@override
String toString() {
  return 'AbsensiModel(id: $id, halaqohId: $halaqohId, guruId: $guruId, tanggal: $tanggal, sesi: $sesi, records: $records, isSynced: $isSynced, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AbsensiModelCopyWith<$Res>  {
  factory $AbsensiModelCopyWith(AbsensiModel value, $Res Function(AbsensiModel) _then) = _$AbsensiModelCopyWithImpl;
@useResult
$Res call({
 String id, String halaqohId, String guruId, DateTime tanggal, String sesi, List<AbsensiRecordEntry> records, bool isSynced, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AbsensiModelCopyWithImpl<$Res>
    implements $AbsensiModelCopyWith<$Res> {
  _$AbsensiModelCopyWithImpl(this._self, this._then);

  final AbsensiModel _self;
  final $Res Function(AbsensiModel) _then;

/// Create a copy of AbsensiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? halaqohId = null,Object? guruId = null,Object? tanggal = null,Object? sesi = null,Object? records = null,Object? isSynced = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,halaqohId: null == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as DateTime,sesi: null == sesi ? _self.sesi : sesi // ignore: cast_nullable_to_non_nullable
as String,records: null == records ? _self.records : records // ignore: cast_nullable_to_non_nullable
as List<AbsensiRecordEntry>,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AbsensiModel].
extension AbsensiModelPatterns on AbsensiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbsensiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbsensiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbsensiModel value)  $default,){
final _that = this;
switch (_that) {
case _AbsensiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbsensiModel value)?  $default,){
final _that = this;
switch (_that) {
case _AbsensiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String halaqohId,  String guruId,  DateTime tanggal,  String sesi,  List<AbsensiRecordEntry> records,  bool isSynced,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbsensiModel() when $default != null:
return $default(_that.id,_that.halaqohId,_that.guruId,_that.tanggal,_that.sesi,_that.records,_that.isSynced,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String halaqohId,  String guruId,  DateTime tanggal,  String sesi,  List<AbsensiRecordEntry> records,  bool isSynced,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AbsensiModel():
return $default(_that.id,_that.halaqohId,_that.guruId,_that.tanggal,_that.sesi,_that.records,_that.isSynced,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String halaqohId,  String guruId,  DateTime tanggal,  String sesi,  List<AbsensiRecordEntry> records,  bool isSynced,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AbsensiModel() when $default != null:
return $default(_that.id,_that.halaqohId,_that.guruId,_that.tanggal,_that.sesi,_that.records,_that.isSynced,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbsensiModel implements AbsensiModel {
  const _AbsensiModel({required this.id, required this.halaqohId, required this.guruId, required this.tanggal, required this.sesi, required final  List<AbsensiRecordEntry> records, this.isSynced = false, required this.createdAt, required this.updatedAt}): _records = records;
  factory _AbsensiModel.fromJson(Map<String, dynamic> json) => _$AbsensiModelFromJson(json);

/// Firestore document ID
@override final  String id;
/// Reference to `/halaqoh/{id}`
@override final  String halaqohId;
/// Reference to `/guru/{id}` — the teacher who recorded attendance
@override final  String guruId;
/// Attendance date (date only, time portion is midnight)
@override final  DateTime tanggal;
/// Session key: 'shubuh', 'dhuha1', 'dhuha2', 'ashar', 'maghrib'
@override final  String sesi;
/// Per-student attendance entries
 final  List<AbsensiRecordEntry> _records;
/// Per-student attendance entries
@override List<AbsensiRecordEntry> get records {
  if (_records is EqualUnmodifiableListView) return _records;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_records);
}

/// Whether this record has been synced to Firestore
@override@JsonKey() final  bool isSynced;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AbsensiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbsensiModelCopyWith<_AbsensiModel> get copyWith => __$AbsensiModelCopyWithImpl<_AbsensiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbsensiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbsensiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.halaqohId, halaqohId) || other.halaqohId == halaqohId)&&(identical(other.guruId, guruId) || other.guruId == guruId)&&(identical(other.tanggal, tanggal) || other.tanggal == tanggal)&&(identical(other.sesi, sesi) || other.sesi == sesi)&&const DeepCollectionEquality().equals(other._records, _records)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,halaqohId,guruId,tanggal,sesi,const DeepCollectionEquality().hash(_records),isSynced,createdAt,updatedAt);

@override
String toString() {
  return 'AbsensiModel(id: $id, halaqohId: $halaqohId, guruId: $guruId, tanggal: $tanggal, sesi: $sesi, records: $records, isSynced: $isSynced, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AbsensiModelCopyWith<$Res> implements $AbsensiModelCopyWith<$Res> {
  factory _$AbsensiModelCopyWith(_AbsensiModel value, $Res Function(_AbsensiModel) _then) = __$AbsensiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String halaqohId, String guruId, DateTime tanggal, String sesi, List<AbsensiRecordEntry> records, bool isSynced, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AbsensiModelCopyWithImpl<$Res>
    implements _$AbsensiModelCopyWith<$Res> {
  __$AbsensiModelCopyWithImpl(this._self, this._then);

  final _AbsensiModel _self;
  final $Res Function(_AbsensiModel) _then;

/// Create a copy of AbsensiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? halaqohId = null,Object? guruId = null,Object? tanggal = null,Object? sesi = null,Object? records = null,Object? isSynced = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AbsensiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,halaqohId: null == halaqohId ? _self.halaqohId : halaqohId // ignore: cast_nullable_to_non_nullable
as String,guruId: null == guruId ? _self.guruId : guruId // ignore: cast_nullable_to_non_nullable
as String,tanggal: null == tanggal ? _self.tanggal : tanggal // ignore: cast_nullable_to_non_nullable
as DateTime,sesi: null == sesi ? _self.sesi : sesi // ignore: cast_nullable_to_non_nullable
as String,records: null == records ? _self._records : records // ignore: cast_nullable_to_non_nullable
as List<AbsensiRecordEntry>,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
