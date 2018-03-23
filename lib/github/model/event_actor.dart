import 'package:json_annotation/json_annotation.dart';

part 'event_actor.g.dart';

@JsonSerializable()
class EventActorModel extends Object with _$EventActorModelSerializerMixin {

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'login')
  String login;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;


  EventActorModel(this.id, this.login, this.avatarUrl);

  factory EventActorModel.fromJson(Map<String, dynamic> json)=>
      _$EventActorModelFromJson(json);

}
