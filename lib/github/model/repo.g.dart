// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

RepoModel _$RepoModelFromJson(Map<String, dynamic> json) =>
    new RepoModel(
        json['id'] as int,
        json['name'] as String,
        json['language'] as String,
        json['stargazers_count'] as int,
        json['html_url'] as String,
        json['owner'] == null
            ? null
            : new OwnerModel.fromJson(json['owner'] as Map<String, dynamic>));

abstract class _$RepoModelSerializerMixin {
  int get id;
  String get name;
  String get language;
  int get starCount;
  String get htmlUrl;
  OwnerModel get ownerModel;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'name': name,
        'language': language,
        'stargazers_count': starCount,
        'html_url': htmlUrl,
        'owner': ownerModel
      };
}
