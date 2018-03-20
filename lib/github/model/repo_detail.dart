import 'package:githubdashboard/github/model/owner.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repo_detail.g.dart';

@JsonSerializable()
class RepoDetailModel extends Object with _$RepoDetailModelSerializerMixin {

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'owner')
  OwnerModel ownerModel;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'full_name')
  String fullName;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: '')
  @JsonKey(name: 'language')
  String language;
  @JsonKey(name: 'fork')
  bool fork;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'stargazers_count')
  int stargazersCount;
  @JsonKey(name: 'forks_count')
  int forksCount;
  @JsonKey(name: 'subscribers_count')
  int subscribersCount;
  @JsonKey(name: 'open_issues')
  int openIssues;
  @JsonKey(name: 'parent')
  RepoDetailModel parent;


  RepoDetailModel(this.id, this.ownerModel, this.name, this.fullName,
      this.description, this.language, this.fork, this.url,
      this.stargazersCount, this.forksCount, this.subscribersCount,
      this.openIssues, this.parent);

  factory RepoDetailModel.fromJson(Map<String, dynamic> json)=>
      _$RepoDetailModelFromJson(json);

  @override
  String toString() {
    return 'RepoDetailModel(id: $id, ownerModel: $ownerModel, name: $name, fullName: $fullName, description: $description,language : $language, fork : $fork, url : $url,stargazersCount :$stargazersCount, forksCount: $forksCount, subscribersCount: $subscribersCount,openIssues :$openIssues)';
  }
}