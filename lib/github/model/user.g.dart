// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) =>
    new UserModel(
        json['name'] as String,
        json['login'] as String,
        json['avatar_url'] as String,
        json['id'] as int,
        json['repos_url'] as String,
        json['email'] as String);

abstract class _$UserModelSerializerMixin {
  String get name;

  String get login;
  String get avatarUrl;
  int get id;
  String get reposUrl;

  String get email;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'name': name,
        'login': login,
        'avatar_url': avatarUrl,
        'id': id,
        'repos_url': reposUrl,
        'email': email
      };
}
