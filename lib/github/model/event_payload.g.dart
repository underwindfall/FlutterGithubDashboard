// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_payload.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

EventPayloadModel _$EventPayloadModelFromJson(Map<String, dynamic> json) =>
    new EventPayloadModel(
        json['action'] == null
            ? null
            : EventActionType.values.singleWhere(
                (x) => x.toString() == 'EventActionType.${json['action']}'),
        json['ref'] as String,
        json['ref_type'] == null
            ? null
            : EventPayloadType.values.singleWhere(
                (x) => x.toString() == 'EventPayloadType.${json['ref_type']}'),
        json['pusher_type'] == null
            ? null
            : EventPayloadType.values.singleWhere((x) =>
        x.toString() == 'EventPayloadType.${json['pusher_type']}'),
        json['description'] as String,
        json['number'] as int,
        json['size'] as int,
        json['pull_request'] == null
            ? null
            : new PullRequestModel.fromJson(
            json['pull_request'] as Map<String, dynamic>));

abstract class _$EventPayloadModelSerializerMixin {
  EventActionType get action;

  String get ref;

  EventPayloadType get refType;

  EventPayloadType get pusherType;

  String get description;

  int get number;

  int get size;

  PullRequestModel get pullRequest;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'action': action == null ? null : action.toString().split('.')[1],
        'ref': ref,
        'ref_type': refType == null ? null : refType.toString().split('.')[1],
        'pusher_type':
        pusherType == null ? null : pusherType.toString().split('.')[1],
        'description': description,
        'number': number,
        'size': size,
        'pull_request': pullRequest
      };
}
