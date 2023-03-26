// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceUserModel _$WorkspaceUserModelFromJson(Map<String, dynamic> json) =>
    WorkspaceUserModel(
      userId: json['userId'] as int?,
      workspaceId: json['workspaceId'] as int?,
      username: json['username'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      birthDay: WorkspaceUserModel._fromJson(json['birthDay'] as String),
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      type: json['type'] as String?,
      checked: json['checked'] as bool?,
    );

Map<String, dynamic> _$WorkspaceUserModelToJson(WorkspaceUserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'workspaceId': instance.workspaceId,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'birthDay': WorkspaceUserModel._toJson(instance.birthDay),
      'email': instance.email,
      'avatar': instance.avatar,
      'type': instance.type,
      'checked': instance.checked,
    };
