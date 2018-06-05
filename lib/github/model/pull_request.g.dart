// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_request.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

PullRequestModel _$PullRequestModelFromJson(Map<String, dynamic> json) =>
    new PullRequestModel(json['title'] as String, json['number'] as int);

abstract class _$PullRequestModelSerializerMixin {
  String get title;

  int get number;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'title': title, 'number': number};
}
