import 'package:githubdashboard/github/model/pull_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_payload.g.dart';

@JsonSerializable()
class EventPayloadModel extends Object with _$EventPayloadModelSerializerMixin {

  @JsonKey(name: 'action')
  EventActionType action;
  @JsonKey(name: 'ref')
  String ref;
  @JsonKey(name: 'ref_type')
  EventPayloadType refType;
  @JsonKey(name: 'pusher_type')
  EventPayloadType pusherType;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'number')
  int number;
  @JsonKey(name: 'size')
  int size;
  @JsonKey(name: 'pull_request')
  PullRequestModel pullRequest;

  EventPayloadModel(this.action, this.ref, this.refType, this.pusherType,
      this.description, this.number, this.size, this.pullRequest);

  factory EventPayloadModel.fromJson(Map<String, dynamic> json)=>
//      _$EventPayloadModelFromJson(json);

}


enum EventPayloadType {
  Branch,
  User,
  Unknown
}

EventPayloadType eventPayloadTypeFromString(String eventPayloadTypeString) {
  switch (eventPayloadTypeString) {
    case 'branch':
      return EventPayloadType.Branch;
    case 'user':
      return EventPayloadType.User;
    default:
      return EventPayloadType.Unknown;
  }
}

enum EventActionType {
  Closed,
  Opened,
  Unknown
}

EventActionType eventActionTypeFromString(String eventActionTypeString) {
  switch (eventActionTypeString) {
    case 'closed':
      return EventActionType.Closed;
    case 'opened':
      return EventActionType.Opened;
    default:
      return EventActionType.Unknown;
  }
}
