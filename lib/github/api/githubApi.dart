import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:githubdashboard/github/constant/constant.dart';
import 'package:githubdashboard/github/model/github_types.dart';

class GithubApi {

  var httpClient = new HttpClient();

  Future<UserModel> getUser(String name) async {
    var url = '$BASE_URL/users/$name?access_token=$TOKEN';
    Map<String, dynamic> decodedJSON = await _getDecodedJson(url);
    return new UserModel.fromJson(decodedJSON);
    /*   var result = "";
    var url = '$BASE_URL/users/$name?access_token=$TOKEN';
//    try {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      var data = JSON.decode(json);
      result = "OK";
      _userMap[result] = UserModel.transformModel(data);
    } else {
      result = 'Error getting IP address:\nHttp status ${response.statusCode}';
      _userMap[result] = UserModel.transformModel(null);
    }
//    } catch (exception) {
//      result = 'Failed getting IP address';
//      _userMap[result]=UserModel.transformModel(null);
//    }
    return _userMap;*/
//    httpClient.getUrl(Uri.parse())
//        .then((HttpClientRequest request) {
//      return request.close();
//    }).then((HttpClientResponse response) {
//      if (response.statusCode == HttpStatus.OK) {
//        response.transform(UTF8.decoder).join().then((json) {
//          return JSON.decode(json);
//        }).then((data) {
//          debugPrint(data);
//          debugPrint(UserModel.transformModel(data).toString());
//          return UserModel.transformModel(data);
//        });
//      }
//    }).then((model) {
//      debugPrint(model);
//      return model;
//    });


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