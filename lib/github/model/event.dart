import 'package:githubdashboard/github/model/event_actor.dart';
import 'package:githubdashboard/github/model/event_payload.dart';
import 'package:githubdashboard/github/model/event_repo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class EventModel extends Object with _$EventModelSerializerMixin {

  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'type')
  EventType type;
  @JsonKey(name: 'actor')
  EventActorModel actor;
  @JsonKey(name: 'org')
  EventActorModel org;
  @JsonKey(name: 'repo')
  EventRepoModel repo;
  @JsonKey(name: 'payload')
  EventPayloadModel payload;

  EventModel(this.id, this.type, this.actor, this.org, this.repo, this.payload);

  factory EventModel.fromJson(Map<String, dynamic> json){
    //      _$EventModelFromJson(json);
    if (json == null) {
      return null;
    } else {
      return new EventModel(
          json['id'] as String,
          eventTypeFromString(json['type']),
          json['actor'] == null
              ? null
              : new EventActorModel.fromJson(
              json['actor'] as Map<String, dynamic>),
          json['org'] == null
              ? null
              : new EventActorModel.fromJson(
              json['org'] as Map<String, dynamic>),
          json['repo'] == null
              ? null
              : new EventRepoModel.fromJson(
              json['repo'] as Map<String, dynamic>),
          json['payload'] == null
              ? null
              : new EventPayloadModel.fromJson(
              json['payload'] as Map<String, dynamic>));
    }
  }
}

enum EventType {
  CreateEvent,
  DeleteEvent,
  ForkEvent,
  PullRequestEvent,
  PushEvent,
  MemberEvent,
  WatchEvent,
  Unknown
}

EventType eventTypeFromString(String eventTypeString) {
  switch (eventTypeString) {
    case 'CreateEvent':
      return EventType.CreateEvent;
    case 'DeleteEvent':
      return EventType.DeleteEvent;
    case 'ForkEvent':
      return EventType.ForkEvent;
    case 'PushEvent':
      return EventType.PushEvent;
    case 'PullRequestEvent':
      return EventType.PullRequestEvent;
    case 'MemberEvent':
      return EventType.MemberEvent;
    case 'WatchEvent':
      return EventType.WatchEvent;
    default:
      return EventType.Unknown;
  }
}