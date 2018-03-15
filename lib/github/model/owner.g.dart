// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

OwnerModel _$OwnerModelFromJson(Map<String, dynamic> json) =>
    new OwnerModel(
        json['login'] as String, json['id'] as int,
        json['avatar_url'] as String);

abstract class _$OwnerModelSerializerMixin {
  String get login;
  int get id;
  String get avatarUrl;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'login': login, 'id': id, 'avatar_url': avatarUrl};
}
