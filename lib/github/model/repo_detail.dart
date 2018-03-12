import 'package:githubdashboard/github/model/owner.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repo_detail.g.dart';

@JsonSerializable()
class RepoDetailModel extends Object with _$RepoDetailModelSerializerMixin {

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'owner')
  OwnerModel ownerModel;
  @JsonKey(name: 'language')
  String language;
  @JsonKey(name: 'description')
  String description;

  RepoDetailModel(this.id, this.name, this.ownerModel, this.language,
      this.description);

  factory RepoDetailModel.fromJson(Map<String, dynamic> json)=>
      _$RepoDetailModelFromJson(json);
}