import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:githubdashboard/github/constant/constant.dart';
import 'package:githubdashboard/github/constant/token.dart';
import 'package:githubdashboard/github/model/repo.dart';
import 'package:githubdashboard/github/model/user.dart';

class GithubApi {
  static final GithubApi _githubApi = new GithubApi._internal();

  factory GithubApi(){
    return _githubApi;
  }

  GithubApi._internal();

  var httpClient = new HttpClient();

  Future<UserModel> getUser(String name) async {
    var url = '$BASE_URL/users/$name?access_token=$TOKEN';
    Map<String, dynamic> decodedJSON = await _getDecodedJson(url);
    return new UserModel.fromJson(decodedJSON);
  }

  Future<List<RepoModel>> getRepos(String name) async {
    var url = '$BASE_URL/users/$name/repos?access_token=$TOKEN';
    var decodedJSON = await _getDecodedJson(url);
    List<RepoModel> repoList = new List<RepoModel>();
    for (var repoJSON in decodedJSON) {
      repoList.add(new RepoModel.fromJson(repoJSON));
    }
    return repoList;
  }


  Future _getDecodedJson(String url) async {
    var uri = Uri.parse(url);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var json = await response.transform(UTF8.decoder).join();
    var decoded = JSON.decode(json);
    return decoded;
  }
}