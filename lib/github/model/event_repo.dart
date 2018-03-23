import 'package:json_annotation/json_annotation.dart';

part 'event_repo.g.dart';

@JsonSerializable()
class EventRepoModel extends Object with _$EventRepoModelSerializerMixin {

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'url')
  String url;

  factory EventRepoModel.fromJson(Map<String, dynamic> json)=>
      _$EventRepoModelFromJson(json);

  EventRepoModel(this.id, this.name, this.url);


}
