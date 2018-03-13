// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repodetailScreen.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

RepoDetailModel _$RepoDetailModelFromJson(Map<String, dynamic> json) =>
    new RepoDetailModel(
        json['id'] as int,
        json['name'] as String,
        json['owner'] == null
            ? null
            : new OwnerModel.fromJson(json['owner'] as Map<String, dynamic>),
        json['language'] as String,
        json['description'] as String);

abstract class _$RepoDetailModelSerializerMixin {
  int get id;

  String get name;

  OwnerModel get ownerModel;

  String get language;

  String get description;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'id': id,
        'name': name,
        'owner': ownerModel,
        'language': language,
        'description': description
      };
}
