// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  identifier: json['identifier'] as String,
  role: json['role'] as String,
  programType: json['programType'] as String?,
  displayName: json['displayName'] as String,
  linkedDocId: json['linkedDocId'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'identifier': instance.identifier,
      'role': instance.role,
      'programType': instance.programType,
      'displayName': instance.displayName,
      'linkedDocId': instance.linkedDocId,
    };
