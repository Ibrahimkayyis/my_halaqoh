// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedbackModel {

/// Firestore document ID (null before creation)
 String? get id;/// Firebase Auth UID of the submitting user
 String get userId;/// User's display name
 String get userName;/// Role of user: 'guru', 'santri', 'admin', 'super_admin'
 String get userRole;/// Login identifier (NIP, NIS, or 'admin')
 String get userIdentifier;/// Feedback category: 'bug', 'saran', 'pertanyaan'
 String get category;/// Short subject / title of the feedback
 String get title;/// Detailed description of the issue or idea
 String get description;/// URLs of uploaded screenshots in Firebase Storage (max 3)
 List<String> get attachmentUrls;/// Application version string (e.g. "1.0.0+1")
 String get appVersion;/// Device manufacturer & model (e.g. "Samsung Galaxy A52")
 String get deviceModel;/// Operating system version (e.g. "Android 13 (SDK 33)")
 String get osVersion;/// Current handling status: 'open', 'in_progress', 'resolved'
 String get status;/// Timestamp when the feedback was created
 DateTime? get createdAt;
/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackModelCopyWith<FeedbackModel> get copyWith => _$FeedbackModelCopyWithImpl<FeedbackModel>(this as FeedbackModel, _$identity);

  /// Serializes this FeedbackModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.userIdentifier, userIdentifier) || other.userIdentifier == userIdentifier)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.attachmentUrls, attachmentUrls)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,userRole,userIdentifier,category,title,description,const DeepCollectionEquality().hash(attachmentUrls),appVersion,deviceModel,osVersion,status,createdAt);

@override
String toString() {
  return 'FeedbackModel(id: $id, userId: $userId, userName: $userName, userRole: $userRole, userIdentifier: $userIdentifier, category: $category, title: $title, description: $description, attachmentUrls: $attachmentUrls, appVersion: $appVersion, deviceModel: $deviceModel, osVersion: $osVersion, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FeedbackModelCopyWith<$Res>  {
  factory $FeedbackModelCopyWith(FeedbackModel value, $Res Function(FeedbackModel) _then) = _$FeedbackModelCopyWithImpl;
@useResult
$Res call({
 String? id, String userId, String userName, String userRole, String userIdentifier, String category, String title, String description, List<String> attachmentUrls, String appVersion, String deviceModel, String osVersion, String status, DateTime? createdAt
});




}
/// @nodoc
class _$FeedbackModelCopyWithImpl<$Res>
    implements $FeedbackModelCopyWith<$Res> {
  _$FeedbackModelCopyWithImpl(this._self, this._then);

  final FeedbackModel _self;
  final $Res Function(FeedbackModel) _then;

/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? userName = null,Object? userRole = null,Object? userIdentifier = null,Object? category = null,Object? title = null,Object? description = null,Object? attachmentUrls = null,Object? appVersion = null,Object? deviceModel = null,Object? osVersion = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,userIdentifier: null == userIdentifier ? _self.userIdentifier : userIdentifier // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,attachmentUrls: null == attachmentUrls ? _self.attachmentUrls : attachmentUrls // ignore: cast_nullable_to_non_nullable
as List<String>,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,deviceModel: null == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String,osVersion: null == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackModel].
extension FeedbackModelPatterns on FeedbackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackModel value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackModel value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String userId,  String userName,  String userRole,  String userIdentifier,  String category,  String title,  String description,  List<String> attachmentUrls,  String appVersion,  String deviceModel,  String osVersion,  String status,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userRole,_that.userIdentifier,_that.category,_that.title,_that.description,_that.attachmentUrls,_that.appVersion,_that.deviceModel,_that.osVersion,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String userId,  String userName,  String userRole,  String userIdentifier,  String category,  String title,  String description,  List<String> attachmentUrls,  String appVersion,  String deviceModel,  String osVersion,  String status,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _FeedbackModel():
return $default(_that.id,_that.userId,_that.userName,_that.userRole,_that.userIdentifier,_that.category,_that.title,_that.description,_that.attachmentUrls,_that.appVersion,_that.deviceModel,_that.osVersion,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String userId,  String userName,  String userRole,  String userIdentifier,  String category,  String title,  String description,  List<String> attachmentUrls,  String appVersion,  String deviceModel,  String osVersion,  String status,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackModel() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.userRole,_that.userIdentifier,_that.category,_that.title,_that.description,_that.attachmentUrls,_that.appVersion,_that.deviceModel,_that.osVersion,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedbackModel implements FeedbackModel {
  const _FeedbackModel({this.id, required this.userId, required this.userName, required this.userRole, required this.userIdentifier, required this.category, required this.title, required this.description, final  List<String> attachmentUrls = const [], required this.appVersion, required this.deviceModel, required this.osVersion, this.status = 'open', this.createdAt}): _attachmentUrls = attachmentUrls;
  factory _FeedbackModel.fromJson(Map<String, dynamic> json) => _$FeedbackModelFromJson(json);

/// Firestore document ID (null before creation)
@override final  String? id;
/// Firebase Auth UID of the submitting user
@override final  String userId;
/// User's display name
@override final  String userName;
/// Role of user: 'guru', 'santri', 'admin', 'super_admin'
@override final  String userRole;
/// Login identifier (NIP, NIS, or 'admin')
@override final  String userIdentifier;
/// Feedback category: 'bug', 'saran', 'pertanyaan'
@override final  String category;
/// Short subject / title of the feedback
@override final  String title;
/// Detailed description of the issue or idea
@override final  String description;
/// URLs of uploaded screenshots in Firebase Storage (max 3)
 final  List<String> _attachmentUrls;
/// URLs of uploaded screenshots in Firebase Storage (max 3)
@override@JsonKey() List<String> get attachmentUrls {
  if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attachmentUrls);
}

/// Application version string (e.g. "1.0.0+1")
@override final  String appVersion;
/// Device manufacturer & model (e.g. "Samsung Galaxy A52")
@override final  String deviceModel;
/// Operating system version (e.g. "Android 13 (SDK 33)")
@override final  String osVersion;
/// Current handling status: 'open', 'in_progress', 'resolved'
@override@JsonKey() final  String status;
/// Timestamp when the feedback was created
@override final  DateTime? createdAt;

/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackModelCopyWith<_FeedbackModel> get copyWith => __$FeedbackModelCopyWithImpl<_FeedbackModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedbackModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.userIdentifier, userIdentifier) || other.userIdentifier == userIdentifier)&&(identical(other.category, category) || other.category == category)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._attachmentUrls, _attachmentUrls)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,userRole,userIdentifier,category,title,description,const DeepCollectionEquality().hash(_attachmentUrls),appVersion,deviceModel,osVersion,status,createdAt);

@override
String toString() {
  return 'FeedbackModel(id: $id, userId: $userId, userName: $userName, userRole: $userRole, userIdentifier: $userIdentifier, category: $category, title: $title, description: $description, attachmentUrls: $attachmentUrls, appVersion: $appVersion, deviceModel: $deviceModel, osVersion: $osVersion, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FeedbackModelCopyWith<$Res> implements $FeedbackModelCopyWith<$Res> {
  factory _$FeedbackModelCopyWith(_FeedbackModel value, $Res Function(_FeedbackModel) _then) = __$FeedbackModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String userId, String userName, String userRole, String userIdentifier, String category, String title, String description, List<String> attachmentUrls, String appVersion, String deviceModel, String osVersion, String status, DateTime? createdAt
});




}
/// @nodoc
class __$FeedbackModelCopyWithImpl<$Res>
    implements _$FeedbackModelCopyWith<$Res> {
  __$FeedbackModelCopyWithImpl(this._self, this._then);

  final _FeedbackModel _self;
  final $Res Function(_FeedbackModel) _then;

/// Create a copy of FeedbackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? userName = null,Object? userRole = null,Object? userIdentifier = null,Object? category = null,Object? title = null,Object? description = null,Object? attachmentUrls = null,Object? appVersion = null,Object? deviceModel = null,Object? osVersion = null,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_FeedbackModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,userIdentifier: null == userIdentifier ? _self.userIdentifier : userIdentifier // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,attachmentUrls: null == attachmentUrls ? _self._attachmentUrls : attachmentUrls // ignore: cast_nullable_to_non_nullable
as List<String>,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,deviceModel: null == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String,osVersion: null == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
