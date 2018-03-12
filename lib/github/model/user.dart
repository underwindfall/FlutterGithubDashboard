import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends Object with _$UserModelSerializerMixin {
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'repos_url')
  String reposUrl;

  UserModel(this.id, this.name, this.avatarUrl, this.reposUrl);

  bool isValid() {
    return name != null;
  }


  @override
  String toString() => 'UserModel($name)';

  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor.
  /// The constructor is named after the source class, in this case User.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}



