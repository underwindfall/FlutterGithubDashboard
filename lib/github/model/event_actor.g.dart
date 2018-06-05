// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_actor.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

EventActorModel _$EventActorModelFromJson(Map<String, dynamic> json) =>
    new EventActorModel(json['id'] as int, json['login'] as String,
        json['avatar_url'] as String);

abstract class _$EventActorModelSerializerMixin {
  int get id;

  String get login;

  String get avatarUrl;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'login': login, 'avatar_url': avatarUrl};
}
