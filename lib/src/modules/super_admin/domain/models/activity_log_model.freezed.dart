// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityLogModel {

/// Firestore document ID (auto-generated)
 String get id;/// Firebase Auth UID of the user who performed the action
 String get userId;/// Role of the actor: `'admin'` | `'guru'` | `'santri'` | `'super_admin'`
 String get userRole;/// Display name of the actor
 String get userName;/// Action type: `'login'` | `'logout'` | `'create'` | `'update'` |
/// `'delete'` | `'save_absensi'` | `'sync_absensi'` | `'add_hafalan'` |
/// `'sync_hafalan'`
 String get action;/// Module name: `'auth'` | `'guru'` | `'santri'` | `'halaqoh'` |
/// `'target_hafalan'` | `'absensi'` | `'hafalan'`
 String get module;/// Firestore doc ID of the affected entity (nullable)
 String? get entityId;/// Human-readable name of the affected entity (nullable)
 String? get entityName;/// Human-readable description of the action in Bahasa Indonesia
 String? get description;/// Additional context data (nullable)
 Map<String, dynamic> get metadata;/// Timestamp of the log entry
 DateTime get createdAt;
/// Create a copy of ActivityLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityLogModelCopyWith<ActivityLogModel> get copyWith => _$ActivityLogModelCopyWithImpl<ActivityLogModel>(this as ActivityLogModel, _$identity);

  /// Serializes this ActivityLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.action, action) || other.action == action)&&(identical(other.module, module) || other.module == module)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityName, entityName) || other.entityName == entityName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userRole,userName,action,module,entityId,entityName,description,const DeepCollectionEquality().hash(metadata),createdAt);

@override
String toString() {
  return 'ActivityLogModel(id: $id, userId: $userId, userRole: $userRole, userName: $userName, action: $action, module: $module, entityId: $entityId, entityName: $entityName, description: $description, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ActivityLogModelCopyWith<$Res>  {
  factory $ActivityLogModelCopyWith(ActivityLogModel value, $Res Function(ActivityLogModel) _then) = _$ActivityLogModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userRole, String userName, String action, String module, String? entityId, String? entityName, String? description, Map<String, dynamic> metadata, DateTime createdAt
});




}
/// @nodoc
class _$ActivityLogModelCopyWithImpl<$Res>
    implements $ActivityLogModelCopyWith<$Res> {
  _$ActivityLogModelCopyWithImpl(this._self, this._then);

  final ActivityLogModel _self;
  final $Res Function(ActivityLogModel) _then;

/// Create a copy of ActivityLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userRole = null,Object? userName = null,Object? action = null,Object? module = null,Object? entityId = freezed,Object? entityName = freezed,Object? description = freezed,Object? metadata = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,entityName: freezed == entityName ? _self.entityName : entityName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityLogModel].
extension ActivityLogModelPatterns on ActivityLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityLogModel value)  $default,){
final _that = this;
switch (_that) {
case _ActivityLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userRole,  String userName,  String action,  String module,  String? entityId,  String? entityName,  String? description,  Map<String, dynamic> metadata,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.userRole,_that.userName,_that.action,_that.module,_that.entityId,_that.entityName,_that.description,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userRole,  String userName,  String action,  String module,  String? entityId,  String? entityName,  String? description,  Map<String, dynamic> metadata,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ActivityLogModel():
return $default(_that.id,_that.userId,_that.userRole,_that.userName,_that.action,_that.module,_that.entityId,_that.entityName,_that.description,_that.metadata,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userRole,  String userName,  String action,  String module,  String? entityId,  String? entityName,  String? description,  Map<String, dynamic> metadata,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ActivityLogModel() when $default != null:
return $default(_that.id,_that.userId,_that.userRole,_that.userName,_that.action,_that.module,_that.entityId,_that.entityName,_that.description,_that.metadata,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityLogModel implements ActivityLogModel {
  const _ActivityLogModel({required this.id, required this.userId, required this.userRole, required this.userName, required this.action, required this.module, this.entityId, this.entityName, this.description, final  Map<String, dynamic> metadata = const {}, required this.createdAt}): _metadata = metadata;
  factory _ActivityLogModel.fromJson(Map<String, dynamic> json) => _$ActivityLogModelFromJson(json);

/// Firestore document ID (auto-generated)
@override final  String id;
/// Firebase Auth UID of the user who performed the action
@override final  String userId;
/// Role of the actor: `'admin'` | `'guru'` | `'santri'` | `'super_admin'`
@override final  String userRole;
/// Display name of the actor
@override final  String userName;
/// Action type: `'login'` | `'logout'` | `'create'` | `'update'` |
/// `'delete'` | `'save_absensi'` | `'sync_absensi'` | `'add_hafalan'` |
/// `'sync_hafalan'`
@override final  String action;
/// Module name: `'auth'` | `'guru'` | `'santri'` | `'halaqoh'` |
/// `'target_hafalan'` | `'absensi'` | `'hafalan'`
@override final  String module;
/// Firestore doc ID of the affected entity (nullable)
@override final  String? entityId;
/// Human-readable name of the affected entity (nullable)
@override final  String? entityName;
/// Human-readable description of the action in Bahasa Indonesia
@override final  String? description;
/// Additional context data (nullable)
 final  Map<String, dynamic> _metadata;
/// Additional context data (nullable)
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

/// Timestamp of the log entry
@override final  DateTime createdAt;

/// Create a copy of ActivityLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityLogModelCopyWith<_ActivityLogModel> get copyWith => __$ActivityLogModelCopyWithImpl<_ActivityLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityLogModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.action, action) || other.action == action)&&(identical(other.module, module) || other.module == module)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityName, entityName) || other.entityName == entityName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userRole,userName,action,module,entityId,entityName,description,const DeepCollectionEquality().hash(_metadata),createdAt);

@override
String toString() {
  return 'ActivityLogModel(id: $id, userId: $userId, userRole: $userRole, userName: $userName, action: $action, module: $module, entityId: $entityId, entityName: $entityName, description: $description, metadata: $metadata, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ActivityLogModelCopyWith<$Res> implements $ActivityLogModelCopyWith<$Res> {
  factory _$ActivityLogModelCopyWith(_ActivityLogModel value, $Res Function(_ActivityLogModel) _then) = __$ActivityLogModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userRole, String userName, String action, String module, String? entityId, String? entityName, String? description, Map<String, dynamic> metadata, DateTime createdAt
});




}
/// @nodoc
class __$ActivityLogModelCopyWithImpl<$Res>
    implements _$ActivityLogModelCopyWith<$Res> {
  __$ActivityLogModelCopyWithImpl(this._self, this._then);

  final _ActivityLogModel _self;
  final $Res Function(_ActivityLogModel) _then;

/// Create a copy of ActivityLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userRole = null,Object? userName = null,Object? action = null,Object? module = null,Object? entityId = freezed,Object? entityName = freezed,Object? description = freezed,Object? metadata = null,Object? createdAt = null,}) {
  return _then(_ActivityLogModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,entityName: freezed == entityName ? _self.entityName : entityName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
