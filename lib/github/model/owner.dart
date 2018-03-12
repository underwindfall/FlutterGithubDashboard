import 'package:json_annotation/json_annotation.dart';

part 'owner.g.dart';

@JsonSerializable()
class OwnerModel extends Object with _$OwnerModelSerializerMixin {
  @JsonKey(name: 'login')
  String login;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;

  OwnerModel(this.login, this.id, this.avatarUrl);

  factory OwnerModel.fromJson(Map<String, dynamic> json)=>
      _$OwnerModelFromJson(json);

}