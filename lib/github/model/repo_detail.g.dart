// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_detail.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

RepoDetailModel _$RepoDetailModelFromJson(Map<String, dynamic> json) =>
    new RepoDetailModel(
        json['id'] as int,
        json['owner'] == null
            ? null
            : new OwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
        json['name'] as String,
        json['full_name'] as String,
        json['description'] as String,
        json[''] as String,
        json['fork'] as bool,
        json['url'] as String,
        json['stargazers_count'] as int,
        json['forks_count'] as int,
        json['subscribers_count'] as int,
        json['open_issues'] as int,
        json['parent'] == null
            ? null
            : new RepoDetailModel.fromJson(
            json['parent'] as Map<String, dynamic>));

abstract class _$RepoDetailModelSerializerMixin {
  int get id;
  OwnerModel get ownerModel;
  String get name;
  String get fullName;
  String get description;
  String get language;
  bool get fork;
  String get url;
  int get stargazersCount;
  int get forksCount;
  int get subscribersCount;
  int get openIssues;
  RepoDetailModel get parent;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'owner': ownerModel,
        'name': name,
        'full_name': fullName,
        'description': description,
        '': language,
        'fork': fork,
        'url': url,
        'stargazers_count': stargazersCount,
        'forks_count': forksCount,
        'subscribers_count': subscribersCount,
        'open_issues': openIssues,
        'parent': parent
      };
}
