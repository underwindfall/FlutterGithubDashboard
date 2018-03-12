import 'package:json_annotation/json_annotation.dart';

part 'repo.g.dart';

@JsonSerializable()
class RepoModel extends Object with _$RepoModelSerializerMixin {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'language')
  String language;
  @JsonKey(name: 'stargazers_count')
  int starCount;
  @JsonKey(name: 'html_url')
  String htmlUrl;


  RepoModel(this.id, this.name, this.language, this.starCount, this.htmlUrl);

  factory RepoModel.fromJson(Map<String, dynamic> json)=>
      _$RepoModelFromJson(json);
}