import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:githubdashboard/github/api/client/OauthClient.dart';
import 'package:githubdashboard/github/constant/constant.dart';
import 'package:githubdashboard/github/model/repo.dart';
import 'package:githubdashboard/github/model/repo_detail.dart';
import 'package:githubdashboard/github/model/user.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GithubApi {
  static final GithubApi _githubApi = new GithubApi._internal();

  factory GithubApi(){
    return _githubApi;
  }

  GithubApi._internal();


  static const String KEY_USERNAME = 'KEY_USERNAME';
//  static const String KEY_PASSWORD = 'KEY_PASSWORD';
  static const String KEY_OAUTH_TOKEN = 'KEY_AUTH_TOKEN';

  bool get initialized => _initialized;

  bool get loggedIn => _loggedIn;

  String get username => _username;

  OauthClient get oauthClient => _oauthClient;

  String get token => _token;

  final String _clientId = CLIENT_ID;
  final String _clientSecret = CLIENT_SECRET;
  final Client _client = new Client();


  bool _initialized;
  bool _loggedIn;
  String _username;
  String _token;
  OauthClient _oauthClient;

  var httpClient = new HttpClient();


  Future init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String username = preferences.getString(KEY_USERNAME);
    String oauthToken = preferences.getString(KEY_OAUTH_TOKEN);
    if (username == null || oauthToken == null) {
      _loggedIn = false;
      await logout();
    } else {
      _loggedIn = true;
      _username = username;
      _token = oauthToken;
      _oauthClient = new OauthClient(_client, oauthToken);
    }
    _initialized = true;
  }

  Future <bool> login(String username, String password) async {
    var basicToken = _getEncodedAuthorization(username, password);
    final requestHeader = {
      'Authorization': 'Basic $basicToken'
    };

    final requestBody = JSON.encode({
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'scopes': ['user', 'repo', 'notifications']
    });

    final loginResponse = await _client.post(
        '$AUTH_URL',
        headers: requestHeader,
        body: requestBody)
        .whenComplete(_client.close);

    if (loginResponse.statusCode == 201) {
      final bodyJson = JSON.decode(loginResponse.body);
      final name = await _getUserName(bodyJson['token']);
      await _saveTokens(name, bodyJson['token']);
      _loggedIn = true;
    } else {
      _loggedIn = false;
    }

    return _loggedIn;
  }

  Future<UserModel> getUser(String name) async {
    var url = '$BASE_URL/users/$name?access_token=$_token';
    Map<String, dynamic> decodedJSON = await _getDecodedJson(url);
    return new UserModel.fromJson(decodedJSON);
  }

  Future<List<RepoModel>> getRepos(String name) async {
    var url = '$BASE_URL/users/$name/repos?access_token=$_token';
    var decodedJSON = await _getDecodedJson(url);
    List<RepoModel> repoList = new List<RepoModel>();
    for (var repoJSON in decodedJSON) {
      repoList.add(new RepoModel.fromJson(repoJSON));
    }
    return repoList;
  }

  Future<RepoDetailModel> getRepoDetail(String repoOwner,
      String repoName) async {
    var url = '$BASE_URL/repos/$repoOwner/$repoName?access_token=$_token';
    var decodedJSON = await _getDecodedJson(url);
    return new RepoDetailModel.fromJson(decodedJSON);
  }


  Future _getDecodedJson(String url) async {
    var uri = Uri.parse(url);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      var decoded = JSON.decode(json);
      return decoded;
    } else {
      throw new Exception('Fetch data network exception');
    }
  }

  _getEncodedAuthorization(String username, String password) {
    final authorizationBytes = UTF8.encode('$username:$password');
    return BASE64.encode(authorizationBytes);
  }

  Future _saveTokens(String username, String oauthToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(KEY_USERNAME, username);
    preferences.setString(KEY_OAUTH_TOKEN, oauthToken);
    await preferences.commit();
    _username = username;
    _oauthClient = new OauthClient(_client, oauthToken);
    _token = oauthToken;
  }

  Future logout() async {
    await _saveTokens(null, null);
    _loggedIn = false;
  }

  Future _getUserName(bodyJson) async{
    var url ='$BASE_URL/user?access_token=$bodyJson';
    Map<String, dynamic> decodedJSON = await _getDecodedJson(url);
    return decodedJSON['login'];
  }

}