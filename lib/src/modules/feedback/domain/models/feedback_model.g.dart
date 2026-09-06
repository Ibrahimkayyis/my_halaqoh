// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) =>
    _FeedbackModel(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userRole: json['userRole'] as String,
      userIdentifier: json['userIdentifier'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      attachmentUrls:
          (json['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      appVersion: json['appVersion'] as String,
      deviceModel: json['deviceModel'] as String,
      osVersion: json['osVersion'] as String,
      status: json['status'] as String? ?? 'open',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$FeedbackModelToJson(_FeedbackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'userRole': instance.userRole,
      'userIdentifier': instance.userIdentifier,
      'category': instance.category,
      'title': instance.title,
      'description': instance.description,
      'attachmentUrls': instance.attachmentUrls,
      'appVersion': instance.appVersion,
      'deviceModel': instance.deviceModel,
      'osVersion': instance.osVersion,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
