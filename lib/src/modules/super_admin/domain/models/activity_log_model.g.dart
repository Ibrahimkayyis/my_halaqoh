// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityLogModel _$ActivityLogModelFromJson(Map<String, dynamic> json) =>
    _ActivityLogModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userRole: json['userRole'] as String,
      userName: json['userName'] as String,
      action: json['action'] as String,
      module: json['module'] as String,
      entityId: json['entityId'] as String?,
      entityName: json['entityName'] as String?,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ActivityLogModelToJson(_ActivityLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userRole': instance.userRole,
      'userName': instance.userName,
      'action': instance.action,
      'module': instance.module,
      'entityId': instance.entityId,
      'entityName': instance.entityName,
      'description': instance.description,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };
