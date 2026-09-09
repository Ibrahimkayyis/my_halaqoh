// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceSessionModel {

/// Unique persistent device identifier
 String get deviceId;/// Human-friendly device name (e.g. "Samsung Galaxy S21")
 String get deviceName;/// Unique session identifier generated on login
 String get sessionId;/// Push notification token for this device
 String? get fcmToken;/// Timestamp of the last activity or login
 DateTime get lastActiveAt;/// OS platform ("android", "ios", etc.)
 String get platform;/// Flag set if this session was terminated remotely
 bool get isTerminated;/// The name of the device that displaced/terminated this session
 String? get terminatedBy;
/// Create a copy of DeviceSessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceSessionModelCopyWith<DeviceSessionModel> get copyWith => _$DeviceSessionModelCopyWithImpl<DeviceSessionModel>(this as DeviceSessionModel, _$identity);

  /// Serializes this DeviceSessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceSessionModel&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.isTerminated, isTerminated) || other.isTerminated == isTerminated)&&(identical(other.terminatedBy, terminatedBy) || other.terminatedBy == terminatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceName,sessionId,fcmToken,lastActiveAt,platform,isTerminated,terminatedBy);

@override
String toString() {
  return 'DeviceSessionModel(deviceId: $deviceId, deviceName: $deviceName, sessionId: $sessionId, fcmToken: $fcmToken, lastActiveAt: $lastActiveAt, platform: $platform, isTerminated: $isTerminated, terminatedBy: $terminatedBy)';
}


}

/// @nodoc
abstract mixin class $DeviceSessionModelCopyWith<$Res>  {
  factory $DeviceSessionModelCopyWith(DeviceSessionModel value, $Res Function(DeviceSessionModel) _then) = _$DeviceSessionModelCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceName, String sessionId, String? fcmToken, DateTime lastActiveAt, String platform, bool isTerminated, String? terminatedBy
});




}
/// @nodoc
class _$DeviceSessionModelCopyWithImpl<$Res>
    implements $DeviceSessionModelCopyWith<$Res> {
  _$DeviceSessionModelCopyWithImpl(this._self, this._then);

  final DeviceSessionModel _self;
  final $Res Function(DeviceSessionModel) _then;

/// Create a copy of DeviceSessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? deviceName = null,Object? sessionId = null,Object? fcmToken = freezed,Object? lastActiveAt = null,Object? platform = null,Object? isTerminated = null,Object? terminatedBy = freezed,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,lastActiveAt: null == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,isTerminated: null == isTerminated ? _self.isTerminated : isTerminated // ignore: cast_nullable_to_non_nullable
as bool,terminatedBy: freezed == terminatedBy ? _self.terminatedBy : terminatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceSessionModel].
extension DeviceSessionModelPatterns on DeviceSessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceSessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceSessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceSessionModel value)  $default,){
final _that = this;
switch (_that) {
case _DeviceSessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceSessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceSessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String deviceName,  String sessionId,  String? fcmToken,  DateTime lastActiveAt,  String platform,  bool isTerminated,  String? terminatedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceSessionModel() when $default != null:
return $default(_that.deviceId,_that.deviceName,_that.sessionId,_that.fcmToken,_that.lastActiveAt,_that.platform,_that.isTerminated,_that.terminatedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String deviceName,  String sessionId,  String? fcmToken,  DateTime lastActiveAt,  String platform,  bool isTerminated,  String? terminatedBy)  $default,) {final _that = this;
switch (_that) {
case _DeviceSessionModel():
return $default(_that.deviceId,_that.deviceName,_that.sessionId,_that.fcmToken,_that.lastActiveAt,_that.platform,_that.isTerminated,_that.terminatedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String deviceName,  String sessionId,  String? fcmToken,  DateTime lastActiveAt,  String platform,  bool isTerminated,  String? terminatedBy)?  $default,) {final _that = this;
switch (_that) {
case _DeviceSessionModel() when $default != null:
return $default(_that.deviceId,_that.deviceName,_that.sessionId,_that.fcmToken,_that.lastActiveAt,_that.platform,_that.isTerminated,_that.terminatedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceSessionModel implements DeviceSessionModel {
  const _DeviceSessionModel({required this.deviceId, required this.deviceName, required this.sessionId, this.fcmToken, required this.lastActiveAt, required this.platform, this.isTerminated = false, this.terminatedBy});
  factory _DeviceSessionModel.fromJson(Map<String, dynamic> json) => _$DeviceSessionModelFromJson(json);

/// Unique persistent device identifier
@override final  String deviceId;
/// Human-friendly device name (e.g. "Samsung Galaxy S21")
@override final  String deviceName;
/// Unique session identifier generated on login
@override final  String sessionId;
/// Push notification token for this device
@override final  String? fcmToken;
/// Timestamp of the last activity or login
@override final  DateTime lastActiveAt;
/// OS platform ("android", "ios", etc.)
@override final  String platform;
/// Flag set if this session was terminated remotely
@override@JsonKey() final  bool isTerminated;
/// The name of the device that displaced/terminated this session
@override final  String? terminatedBy;

/// Create a copy of DeviceSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceSessionModelCopyWith<_DeviceSessionModel> get copyWith => __$DeviceSessionModelCopyWithImpl<_DeviceSessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceSessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceSessionModel&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.isTerminated, isTerminated) || other.isTerminated == isTerminated)&&(identical(other.terminatedBy, terminatedBy) || other.terminatedBy == terminatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceName,sessionId,fcmToken,lastActiveAt,platform,isTerminated,terminatedBy);

@override
String toString() {
  return 'DeviceSessionModel(deviceId: $deviceId, deviceName: $deviceName, sessionId: $sessionId, fcmToken: $fcmToken, lastActiveAt: $lastActiveAt, platform: $platform, isTerminated: $isTerminated, terminatedBy: $terminatedBy)';
}


}

/// @nodoc
abstract mixin class _$DeviceSessionModelCopyWith<$Res> implements $DeviceSessionModelCopyWith<$Res> {
  factory _$DeviceSessionModelCopyWith(_DeviceSessionModel value, $Res Function(_DeviceSessionModel) _then) = __$DeviceSessionModelCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String deviceName, String sessionId, String? fcmToken, DateTime lastActiveAt, String platform, bool isTerminated, String? terminatedBy
});




}
/// @nodoc
class __$DeviceSessionModelCopyWithImpl<$Res>
    implements _$DeviceSessionModelCopyWith<$Res> {
  __$DeviceSessionModelCopyWithImpl(this._self, this._then);

  final _DeviceSessionModel _self;
  final $Res Function(_DeviceSessionModel) _then;

/// Create a copy of DeviceSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceName = null,Object? sessionId = null,Object? fcmToken = freezed,Object? lastActiveAt = null,Object? platform = null,Object? isTerminated = null,Object? terminatedBy = freezed,}) {
  return _then(_DeviceSessionModel(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,lastActiveAt: null == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,isTerminated: null == isTerminated ? _self.isTerminated : isTerminated // ignore: cast_nullable_to_non_nullable
as bool,terminatedBy: freezed == terminatedBy ? _self.terminatedBy : terminatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
