// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) =>
    new EventModel(
        json['id'] as String,
        json['type'] == null
            ? null
            : EventType.values
            .singleWhere((x) => x.toString() == 'EventType.${json['type']}'),
        json['actor'] == null
            ? null
            : new EventActorModel.fromJson(
            json['actor'] as Map<String, dynamic>),
        json['org'] == null
            ? null
            : new EventActorModel.fromJson(json['org'] as Map<String, dynamic>),
        json['repo'] == null
            ? null
            : new EventRepoModel.fromJson(json['repo'] as Map<String, dynamic>),
        json['payload'] == null
            ? null
            : new EventPayloadModel.fromJson(
            json['payload'] as Map<String, dynamic>));

abstract class _$EventModelSerializerMixin {
  String get id;

  EventType get type;

  EventActorModel get actor;

  EventActorModel get org;

  EventRepoModel get repo;

  EventPayloadModel get payload;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'type': type == null ? null : type.toString().split('.')[1],
        'actor': actor,
        'org': org,
        'repo': repo,
        'payload': payload
      };
}
