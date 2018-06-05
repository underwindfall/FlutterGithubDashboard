import 'package:json_annotation/json_annotation.dart';

part 'pull_request.g.dart';

@JsonSerializable()
class PullRequestModel extends Object with _$PullRequestModelSerializerMixin {

  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'number')
  int number;


  PullRequestModel(this.title, this.number);

  factory PullRequestModel.fromJson(Map<String, dynamic> json)=>
      _$PullRequestModelFromJson(json);

}