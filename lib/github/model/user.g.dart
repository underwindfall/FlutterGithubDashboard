// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) =>
    new UserModel(
        json['id'] as int,
        json['name'] as String,
        json['avatar_url'] as String,
        json['repos_url'] as String);

abstract class _$UserModelSerializerMixin {
  String get name;
  String get avatarUrl;
  int get id;
  String get reposUrl;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'name': name,
        'avatar_url': avatarUrl,
        'id': id,
        'repos_url': reposUrl
      };
}
