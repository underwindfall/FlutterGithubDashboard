// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_repo.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

EventRepoModel _$EventRepoModelFromJson(Map<String, dynamic> json) =>
    new EventRepoModel(
        json['id'] as int, json['name'] as String, json['url'] as String);

abstract class _$EventRepoModelSerializerMixin {
  int get id;

  String get name;

  String get url;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'name': name, 'url': url};
}
